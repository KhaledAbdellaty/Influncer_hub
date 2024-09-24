from django.contrib import admin
from .models import (
    Campaign,
    Negotiation,
    Analytics,
    Review,
    Portfolio,
    Project
)


admin.site.register(Campaign)
admin.site.register(Negotiation)
admin.site.register(Analytics)
admin.site.register(Review)
admin.site.register(Portfolio)
admin.site.register(Project)
