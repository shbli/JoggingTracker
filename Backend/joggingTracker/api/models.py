from django.db import models
from django.conf import settings


# Create your models here.
class Jog(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="jog")
    notes = models.TextField()
    created = models.DateTimeField()
    modified = models.DateTimeField()
    activity_start_time = models.DateTimeField(help_text='The starting date and time for a jog')
    distance = models.IntegerField(help_text='Distance in meters')
    time = models.IntegerField(help_text='Time in minutes')
