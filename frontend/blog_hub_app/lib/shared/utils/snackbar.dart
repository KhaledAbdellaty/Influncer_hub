import 'package:flutter/material.dart';

const double _singleLineVerticalPadding = 14.0;

const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);
const Duration _snackBarTransitionDuration = Duration(milliseconds: 250);
const Curve _snackBarHeightCurve = Curves.fastOutSlowIn;
const Curve _snackBarFadeInCurve =
    Interval(0.45, 1.0, curve: Curves.fastOutSlowIn);
const Curve _snackBarFadeOutCurve =
    Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

class LisSnackBar extends SnackBar {
  /// Creates a snack bar.
  ///
  /// The [content] argument must be non-null. The [elevation] must be null or
  /// non-negative.
  const LisSnackBar({
    Key? key,
    required Widget content,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    Duration duration = _snackBarDisplayDuration,
    Animation<double>? animation,
    VoidCallback? onVisible,
    DismissDirection? dismissDirection = DismissDirection.down,
  })  : assert(elevation == null || elevation >= 0.0),
        assert(content != null),
        assert(
          width == null || margin == null,
          'Width and margin can not be used together',
        ),
        assert(duration != null),
        super(
          key: key,
          content: content,
          backgroundColor: backgroundColor,
          elevation: elevation,
          margin: margin,
          padding: padding,
          width: width,
          shape: shape,
          behavior: behavior,
          action: action,
          duration: duration,
          animation: animation,
          onVisible: onVisible,
          dismissDirection: dismissDirection,
        );

  /// Creates a copy of this snack bar but with the animation replaced with the given animation.
  ///
  /// If the original snack bar lacks a key, the newly created snack bar will
  /// use the given fallback key.
  @override
  SnackBar withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) {
    return LisSnackBar(
      key: key ?? fallbackKey,
      content: content,
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      behavior: behavior,
      action: action,
      duration: duration,
      animation: newAnimation,
      onVisible: onVisible,
      dismissDirection: dismissDirection,
    );
  }

  @override
  State<LisSnackBar> createState() => _SnackBarState();
}

class _SnackBarState extends State<LisSnackBar> {
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    widget.animation!.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void didUpdateWidget(LisSnackBar oldWidget) {
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation!.removeStatusListener(_onAnimationStatusChanged);
      widget.animation!.addStatusListener(_onAnimationStatusChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation!.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus animationStatus) {
    switch (animationStatus) {
      case AnimationStatus.dismissed:
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
        if (widget.onVisible != null && !_wasVisible) {
          widget.onVisible!();
        }
        _wasVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final mediaQueryData = MediaQuery.of(context);
    assert(widget.animation != null);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final snackBarTheme = theme.snackBarTheme;
    final isThemeDark = theme.brightness == Brightness.dark;
    final buttonColor =
        isThemeDark ? colorScheme.primary : colorScheme.secondary;

    // SnackBar uses a theme that is the opposite brightness from
    // the surrounding theme.
    final brightness = isThemeDark ? Brightness.light : Brightness.dark;
    final themeBackgroundColor = isThemeDark
        ? colorScheme.onSurface
        : Color.alphaBlend(
            colorScheme.onSurface.withOpacity(0.80), colorScheme.surface);
    final inverseTheme = theme.copyWith(
      colorScheme: ColorScheme(
        primary: colorScheme.onPrimary,
        primaryContainer: colorScheme.onPrimary,
        // For the button color, the spec says it should be primaryVariant, but for
        // backward compatibility on light themes we are leaving it as secondary.
        secondary: buttonColor,
        secondaryContainer: colorScheme.onSecondary,
        surface: colorScheme.onSurface,
        background: themeBackgroundColor,
        error: colorScheme.onError,
        onPrimary: colorScheme.primary,
        onSecondary: colorScheme.secondary,
        onSurface: colorScheme.surface,
        onBackground: colorScheme.background,
        onError: colorScheme.error,
        brightness: brightness,
      ),
    );

    final contentTextStyle = snackBarTheme.contentTextStyle ??
        ThemeData(brightness: brightness).textTheme.subtitle1;
    final snackBarBehavior =
        widget.behavior ?? snackBarTheme.behavior ?? SnackBarBehavior.fixed;
    assert(() {
      // Whether the behavior is set through the constructor or the theme,
      // assert that our other properties are configured properly.
      if (snackBarBehavior != SnackBarBehavior.floating) {
        String message(String parameter) {
          final prefix = '$parameter can only be used with floating behavior.';
          if (widget.behavior != null) {
            return '$prefix SnackBarBehavior.fixed was set in the SnackBar constructor.';
          } else if (snackBarTheme.behavior != null) {
            return '$prefix SnackBarBehavior.fixed was set by the inherited SnackBarThemeData.';
          } else {
            return '$prefix SnackBarBehavior.fixed was set by default.';
          }
        }

        assert(widget.margin == null, message('Margin'));
        assert(widget.width == null, message('Width'));
      }
      return true;
    }());

    final isFloatingSnackBar = snackBarBehavior == SnackBarBehavior.floating;
    final horizontalPadding = isFloatingSnackBar ? 16.0 : 24.0;
    final padding = widget.padding ??
        EdgeInsetsDirectional.only(
            start: horizontalPadding,
            end: widget.action != null ? 0 : horizontalPadding);

    final actionHorizontalMargin =
        (widget.padding?.resolve(TextDirection.ltr).right ??
                horizontalPadding) /
            2;

    final heightAnimation =
        CurvedAnimation(parent: widget.animation!, curve: _snackBarHeightCurve);
    final fadeInAnimation =
        CurvedAnimation(parent: widget.animation!, curve: _snackBarFadeInCurve);
    final fadeOutAnimation = CurvedAnimation(
      parent: widget.animation!,
      curve: _snackBarFadeOutCurve,
      reverseCurve: const Threshold(0.0),
    );

    Widget snackBar = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: widget.padding == null
                  ? const EdgeInsets.symmetric(
                      vertical: _singleLineVerticalPadding)
                  : null,
              child: DefaultTextStyle(
                style: contentTextStyle!,
                child: widget.content,
              ),
            ),
          ),
          if (widget.action != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: actionHorizontalMargin),
              child: TextButtonTheme(
                data: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    iconColor: buttonColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                  ),
                ),
                child: widget.action!,
              ),
            ),
        ],
      ),
    );

    if (!isFloatingSnackBar) {
      snackBar = SafeArea(
        top: false,
        child: snackBar,
      );
    }

    final elevation = widget.elevation ?? snackBarTheme.elevation ?? 6.0;
    final backgroundColor = widget.backgroundColor ??
        snackBarTheme.backgroundColor ??
        inverseTheme.colorScheme.background;
    final shape = widget.shape ??
        snackBarTheme.shape ??
        (isFloatingSnackBar
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
            : null);

    snackBar = Material(
      shape: shape,
      elevation: elevation,
      color: backgroundColor,
      child: Theme(
        data: inverseTheme,
        child: mediaQueryData.accessibleNavigation
            ? snackBar
            : FadeTransition(
                opacity: fadeOutAnimation,
                child: snackBar,
              ),
      ),
    );

    if (isFloatingSnackBar) {
      const topMargin = 5.0;
      const bottomMargin = 10.0;
      // If width is provided, do not include horizontal margins.
      if (widget.width != null) {
        snackBar = Container(
          margin: const EdgeInsets.only(top: topMargin, bottom: bottomMargin),
          width: widget.width,
          child: snackBar,
        );
      } else {
        const horizontalMargin = 15.0;
        snackBar = Padding(
          padding: widget.margin ??
              const EdgeInsets.fromLTRB(
                horizontalMargin,
                topMargin,
                horizontalMargin,
                bottomMargin,
              ),
          child: snackBar,
        );
      }
      snackBar = SafeArea(
        top: false,
        bottom: false,
        child: snackBar,
      );
    }

    snackBar = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () {
        ScaffoldMessenger.of(context)
            .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
      },
      child: Dismissible(
        key: const Key('dismissible'),
        direction: widget.dismissDirection!,
        resizeDuration: null,
        onDismissed: (direction) {
          ScaffoldMessenger.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.swipe);
        },
        child: snackBar,
      ),
    );

    final Widget snackBarTransition;
    if (mediaQueryData.accessibleNavigation) {
      snackBarTransition = snackBar;
    } else if (isFloatingSnackBar) {
      snackBarTransition = FadeTransition(
        opacity: fadeInAnimation,
        child: snackBar,
      );
    } else {
      snackBarTransition = AnimatedBuilder(
        animation: heightAnimation,
        builder: (context, child) {
          return Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: heightAnimation.value,
            child: child,
          );
        },
        child: snackBar,
      );
    }

    return IgnorePointer(
      child: Hero(
        tag: '<SnackBar Hero tag - ${widget.content}>',
        child: ClipRect(child: snackBarTransition),
      ),
    );
  }
}