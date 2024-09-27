#!/usr/bin/env python3
"""
Endpoints api's URL
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ProfileViewSet, CampaignViewSet, NegotiationViewSet,
    AnalyticsViewSet, ReviewViewSet, PortfolioViewSet,
    ProjectViewSet, InfluencerDetailView, InfluencerSearchView
    )

router = DefaultRouter()
router.register(r'profile', ProfileViewSet)
router.register(r'campaigns', CampaignViewSet)
router.register(r'negotiations', NegotiationViewSet)
router.register(r'analytics', AnalyticsViewSet)
router.register(r'reviews', ReviewViewSet)
router.register(r'portfolio', PortfolioViewSet)
router.register(r'projects', ProjectViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path(
        'recommendations/',
        ProfileViewSet.as_view({'get': 'recommendations'}),
        name='recommendations'
        ),
    path(
        'influencers/search/',
        InfluencerSearchView.as_view(),
        name='influencer-search'
        ),
    path(
        'influencers/<int:pk>/',
        InfluencerDetailView.as_view(),
        name='influencer-detail'
        ),
]
