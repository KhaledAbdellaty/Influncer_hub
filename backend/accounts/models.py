from django.db import models
from django.db.models.signals import post_save
from django.contrib.auth.models import AbstractUser

# Create your models here.

class User(AbstractUser):
    """
    A User class that inhert from AbstractUser to
    override the default user attributes, and
    logging by email field. 
    """
    # Override the default logging to be by email field 
    ROLE_CHOICES = (
        ('BRAND', 'Brand'),
        ('INFLUENCER', 'Influencer'),
    )
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, null=False)
    niche = models.CharField(max_length=100, blank=True)
    REQUIRED_FIELDS = ['username']
    USERNAME_FIELD = "email"

    def __str__(self):
        return self.username

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.TextField(blank=True)
    social_links = models.JSONField(default=dict)
    followers_count = models.PositiveIntegerField(default=0)
    engagement_rate = models.FloatField(default=0.0)

    def __str__(self):
        return f"{self.user.username}'s Profile"


def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)

def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()

post_save.connect(create_user_profile, sender=User)
post_save.connect(save_user_profile, sender=User)