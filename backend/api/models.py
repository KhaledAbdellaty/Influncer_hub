#!/usr/bin/env python3
"""
Database module
"""
from django.db import models
from django.contrib.auth import get_user_model
from django.core.validators import (
    MinValueValidator,
    MaxValueValidator
    )


User = get_user_model()


class Campaign(models.Model):
    """
    A Campaign class that store in the database.
    """
    brand = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    budget = models.FloatField()
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()

    def __str__(self):
        """Return the title as reference to the object"""
        return self.title


class Negotiation(models.Model):
    """
    A Negotiation class that store in the database.
    """
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('ACCEPTED', 'Accepted'),
        ('DECLINED', 'Declined'),
    )

    campaign = models.ForeignKey(Campaign, on_delete=models.CASCADE)
    influencer = models.ForeignKey(User, on_delete=models.CASCADE)
    status = models.CharField(
        max_length=10, choices=STATUS_CHOICES, default='PENDING'
        )
    negotiation_details = models.TextField()

    def __str__(self):
        """Return the username and campain title as reference to the object"""
        return f"{self.influencer.username} - {self.campaign.title}"


class Analytics(models.Model):
    """
    A Analytics class that store in the database.
    """
    campaign = models.ForeignKey(Campaign, on_delete=models.CASCADE)
    impressions = models.PositiveIntegerField(default=0)
    clicks = models.PositiveIntegerField(default=0)
    conversions = models.PositiveIntegerField(default=0)
    engagement_rate = models.FloatField(default=0.0)
    roi = models.FloatField(default=0.0)

    def __str__(self):
        """Return the analytics title as reference to the object"""
        return f"Analytics for {self.campaign.title}"


class Review(models.Model):
    """
    A Review class that store in the database.
    """
    reviewer = models.ForeignKey(
        User, on_delete=models.CASCADE,
        related_name='reviews_given'
        )
    reviewed_user = models.ForeignKey(
        User, on_delete=models.CASCADE,
        related_name='reviews_received'
        )
    campaign = models.ForeignKey(Campaign, on_delete=models.CASCADE)
    rating = models.FloatField(
        validators=[MinValueValidator(0.0), MaxValueValidator(5.0)]
        )
    comment = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        """Return the username as reference to the object"""
        return f"Review by {self.reviewer.username} for {self.reviewed_user.username}"


class Portfolio(models.Model):
    """
    A Portfolio class that store in the database.
    """
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    video_url = models.URLField()
    platform = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        """
        Return the user name and portfolio title
        as reference to the object
        """
        return f"{self.user.username}'s Portfolio: {self.title}"


class Project(models.Model):
    """
    A Project class that store in the database.
    """
    influncer = models.ForeignKey(User, on_delete=models.CASCADE)
    campaign = models.ForeignKey(Campaign, on_delete=models.CASCADE)
    title = models.CharField(max_length=200)
    description = models.TextField()
    results = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        """
        Return the user name and project title
        as reference to the object
        """
        return f"{self.brand.username}'s Project: {self.title}"
