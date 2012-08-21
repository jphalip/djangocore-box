DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'djangotests',
        'USER': 'postgres',
        'HOST': 'localhost',
        'PASSWORD': 'secret',
    },
    'other': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'djangotests_other',
        'USER': 'postgres',
        'HOST': 'localhost',
        'PASSWORD': 'secret',
    },
}

SECRET_KEY = 'django_tests_secret_key'
PASSWORD_HASHERS = (
    'django.contrib.auth.hashers.MD5PasswordHasher',
)