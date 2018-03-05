from django.apps import AppConfig
from django.contrib.auth.models import User, Group
from django.db.models.signals import post_save

# A method to add created users to RegularUser group automatically
def add_to_default_group(sender, **kwargs):
    user = kwargs["instance"]
    if kwargs["created"]:
        group = Group.objects.get(name='RegularUser')
        user.groups.add(group)


class ApiConfig(AppConfig):
    name = 'api'
    def ready(self):
        post_save.connect(add_to_default_group, sender=User)
