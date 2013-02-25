DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.spatialite',
    },
    'other': {
        'ENGINE': 'django.contrib.gis.db.backends.spatialite',
    }
}

SECRET_KEY = "django_tests_secret_key"
PASSWORD_HASHERS = (
    'django.contrib.auth.hashers.MD5PasswordHasher',
)
