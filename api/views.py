from django.db.models import Q
from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action
from django.shortcuts import get_object_or_404
from django.contrib.auth import get_user_model
from accounts.models import Profile
from .models import  Campaign, Negotiation, Analytics, Review, Portfolio, Project
from accounts.serializers import UserSerializer, ProfileSerializer
from .serializers import (
    CampaignSerializer,
    NegotiationSerializer,
    AnalyticsSerializer,
    ReviewSerializer,
    ProjectSerializer,
    PortfolioSerializer,
)

User = get_user_model()

class ProfileViewSet(viewsets.ModelViewSet):
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
    queryset = Campaign.objects.all()
    serializer_class = CampaignSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(brand=self.request.user)


class NegotiationViewSet(viewsets.ModelViewSet):
    queryset = Negotiation.objects.all()
    serializer_class = NegotiationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Negotiation.objects.filter(Q(campaign__brand=user) | Q(influencer=user))


class AnalyticsViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Analytics.objects.all()
    serializer_class = AnalyticsSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Analytics.objects.filter(campaign__brand=user)

class ReviewViewSet(viewsets.ModelViewSet):
    queryset = Review.objects.all()
    serializer_class = ReviewSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(reviewer=self.request.user)

class PortfolioViewSet(viewsets.ModelViewSet):
    queryset = Portfolio.objects.all()
    serializer_class = PortfolioSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Portfolio.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class ProjectViewSet(viewsets.ModelViewSet):
    queryset = Project.objects.all()
    serializer_class = ProjectSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Project.objects.filter(brand=self.request.user)

    def perform_create(self, serializer):
        serializer.save(brand=self.request.user)

@action(detail=False, methods=['GET'])
def recommendations(self, request):
    niche = request.query_params.get('niche')
    if not niche:
        return Response({"error": "Niche parameter is required"}, status=status.HTTP_400_BAD_REQUEST)
    
    recommended_users = User.objects.filter(niche=niche).exclude(id=request.user.id)
    serializer = UserSerializer(recommended_users, many=True)
    return Response(serializer.data)
