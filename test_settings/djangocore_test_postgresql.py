DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'djangotests',
        'USER': 'django',
        'HOST': 'localhost',
        'PASSWORD': 'secret',
    },
    'other': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'djangotests_other',
        'USER': 'django',
        'HOST': 'localhost',
        'PASSWORD': 'secret',
    },
}

SECRET_KEY = 'django_tests_secret_key'
PASSWORD_HASHERS = (
    'django.contrib.auth.hashers.MD5PasswordHasher',
)

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}
