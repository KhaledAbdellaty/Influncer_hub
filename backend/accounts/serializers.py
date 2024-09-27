#!/usr/bin/env python3
"""
Serializer that convert object
to JSON and vice versa.
"""
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from rest_framework import serializers
from .models import Profile

User = get_user_model()


class ProfileSerializer(serializers.ModelSerializer):
    """
    Serializes the Profile model,
    including the associated user data.
    """
    class Meta:
        model = Profile
        fields = '__all__'
        read_only_fields = ['id', "user"]

    def update(self, instance, validated_data):
        data = super().update(instance, validated_data)
        print(data)
        return data


class UserSerializer(serializers.ModelSerializer):
    """
    Serializes the User model,
    including fields like id, username, email,
    role, profile and niche.
    """
    profile = ProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = '__all__'
        read_only_fields = [
            'id',
            "email",
            "username",
            "date_joined",
            "role"
            ]

    def get_fields(self):
        fields = super().get_fields()
        fields.pop('password')
        fields.pop('groups')
        fields.pop('user_permissions')
        fields.pop('is_active')
        fields.pop('is_staff')
        fields.pop('is_superuser')
        return fields


class UserRegistrationSerializer(serializers.ModelSerializer):
    """
    Define the structure for registration parameters.
    """
    password = serializers.CharField(
        write_only=True, required=True,
        validators=[validate_password]
        )
    password2 = serializers.CharField(
        write_only=True, required=True
        )

    class Meta:
        model = User
        fields = (
            'username', 'email', 'password',
            'password2', 'role', 'niche'
            )

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError(
                {"password": "Password fields didn't match."}
                )
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(**validated_data)
        return user


class UserLoginSerializer(serializers.Serializer):
    """
    Define the structure for login parameters.
    """
    email = serializers.CharField(required=True)
    password = serializers.CharField(required=True, write_only=True)
