#!/usr/bin/env python3
"""
view module
"""
from django.contrib.auth import authenticate
from django.core.cache import cache
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.views import APIView
from .serializers import (
    UserSerializer,
    UserRegistrationSerializer,
    UserLoginSerializer,
    )


class UserRegistrationView(generics.CreateAPIView):
    """
    API view for user registration.
    Concrete view for creating a model instance.
    """
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({
                "message": "Account created successfully",
                "user": serializer.data,
            }, status=status.HTTP_201_CREATED)
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST)


class UserLoginView(generics.CreateAPIView):
    """
    API view for user login.
    Concrete view for creating a model instance.
    """
    serializer_class = UserLoginSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = authenticate(
                email=serializer.validated_data['email'],
                password=serializer.validated_data['password']
            )
            if user:
                refresh = RefreshToken.for_user(user)
                user_serializer = UserSerializer(user)
                user_data = user_serializer.data
                cache.set('access', str(refresh.access_token),
                          timeout=(60 * 180))
                cache.set('refresh', str(refresh), timeout=(864000))
                cache.set('pk', str(user.pk))
                return Response({
                    "refresh": str(refresh),
                    "access": str(refresh.access_token),
                    "user": user_data
                })
            return Response(
                {"error": "Invalid credentials"},
                status=status.HTTP_401_UNAUTHORIZED)
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST)


class UserLogoutView(APIView):
    """
    API view for user logout.
    Concrete view for send POST method
    """
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        try:
            refresh = cache.get('refresh')
            token = RefreshToken(refresh)
            token.blacklist()
            cache.delete_many(['access', 'refresh'])
            return Response(status=status.HTTP_205_RESET_CONTENT)
        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)
