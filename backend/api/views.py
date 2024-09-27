#!/usr/bin/env python3
"""
view module
"""
from django.db.models import Q
from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import (
    viewsets, permissions,
    status, filters, generics)
from rest_framework.response import Response
from rest_framework.decorators import action
from accounts.models import Profile
from .models import (
    Campaign, Negotiation, Analytics,
    Review, Portfolio, Project)
from accounts.serializers import (
    UserSerializer, ProfileSerializer)
from .serializers import (
    CampaignSerializer,
    NegotiationSerializer,
    AnalyticsSerializer,
    ReviewSerializer,
    ProjectSerializer,
    PortfolioSerializer,
    InfluencerListSerializer,
    SearchSerializer
)

User = get_user_model()


class UserViewSet(viewsets.ModelViewSet):
    """
    The User view that updates user fields.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'put', 'patch', 'head', 'options']

class ProfileViewSet(viewsets.ModelViewSet):
    """
    The Profile view that handles CRUD operations.
    """
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'put', 'patch', 'head', 'options']

    def get_queryset(self):
        return Profile.objects.filter(user=self.request.user)

    @action(detail=False, methods=['GET'])
    def me(self, request):
        profile = get_object_or_404(Profile, user=request.user)
        serializer = self.get_serializer(profile)
        return Response(serializer.data)


class CampaignViewSet(viewsets.ModelViewSet):
    """
    The Campaign view that handles CRUD operations.
    """
    queryset = Campaign.objects.all()
    serializer_class = CampaignSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(brand=self.request.user)


class NegotiationViewSet(viewsets.ModelViewSet):
    """
    The Negotiation view that handles CRUD operations.
    """
    queryset = Negotiation.objects.all()
    serializer_class = NegotiationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Negotiation.objects.filter(
            Q(campaign__brand=user) |
            Q(influencer=user)
            )


class AnalyticsViewSet(viewsets.ReadOnlyModelViewSet):
    """
    The Analytics view that handles CRUD operations.
    """
    queryset = Analytics.objects.all()
    serializer_class = AnalyticsSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Analytics.objects.filter(campaign__brand=user)


class ReviewViewSet(viewsets.ModelViewSet):
    """
    The Review view that handles CRUD operations.
    """
    queryset = Review.objects.all()
    serializer_class = ReviewSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(reviewer=self.request.user)


class PortfolioViewSet(viewsets.ModelViewSet):
    """
    The Portfolio view that handles CRUD operations.
    """
    queryset = Portfolio.objects.all()
    serializer_class = PortfolioSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Portfolio.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ProjectViewSet(viewsets.ModelViewSet):
    """
    The Project view that handles CRUD operations.
    """
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Project.objects.filter(brand=self.request.user)

    def perform_create(self, serializer):
        serializer.save(brand=self.request.user)


@action(detail=False, methods=['GET'])
def recommendations(self, request):
    """
    Retrieving recommendations influncer
    about a specific niche.
    """
    niche = request.query_params.get('niche')
    if not niche:
        return Response(
            {"error": "Niche parameter is required"},
            status=status.HTTP_400_BAD_REQUEST
            )

    recommended_users = User.objects.filter(
        niche=niche).exclude(id=request.user.id)
    serializer = UserSerializer(recommended_users, many=True)
    return Response(serializer.data)


class InfluencerSearchView(generics.ListAPIView):
    """
    The main search and filter view.
    Filters the User queryset to only include
    users with the 'INFLUENCER' role.
    """
    serializer_class = InfluencerListSerializer
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    ordering_fields = ['profile__followers_count', 'profile__engagement_rate']

    def get_queryset(self):
        queryset = User.objects.filter(
            role='INFLUENCER').select_related('profile')
        search_serializer = SearchSerializer(data=self.request.query_params)
        search_serializer.is_valid(raise_exception=True)

        query = search_serializer.validated_data.get('query')
        niche = search_serializer.validated_data.get('niche')
        min_followers = search_serializer.validated_data.get('min_followers')
        max_followers = search_serializer.validated_data.get('max_followers')
        min_engagement = search_serializer.validated_data.get('min_engagement')
        max_engagement = search_serializer.validated_data.get('max_engagement')

        if query:
            queryset = queryset.filter(
                Q(username__icontains=query) |
                Q(email__icontains=query) |
                Q(profile__bio__icontains=query)
            )

        if niche:
            queryset = queryset.filter(niche__icontains=niche)

        if min_followers is not None:
            queryset = queryset.filter(
                profile__followers_count__gte=min_followers
                )

        if max_followers is not None:
            queryset = queryset.filter(
                profile__followers_count__lte=max_followers
                )

        if min_engagement is not None:
            queryset = queryset.filter(
                profile__engagement_rate__gte=min_engagement
                )

        if max_engagement is not None:
            queryset = queryset.filter(
                profile__engagement_rate__lte=max_engagement
                )

        return queryset.distinct()


class InfluencerDetailView(generics.RetrieveAPIView):
    """
    Retrieving detailed
    information about a specific influencer.
    """
    queryset = User.objects.filter(role='INFLUENCER')
    serializer_class = InfluencerListSerializer
