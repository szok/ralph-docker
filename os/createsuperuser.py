
import os
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ralph.settings")

from django.contrib.auth.models import User

user_ralph = User.objects.get(username='ralph')
user_ralph.set_password('ralph')
user_ralph.is_superuser = True
user_ralph.is_staff = True
user_ralph.save()
