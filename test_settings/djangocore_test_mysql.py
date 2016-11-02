DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'djangotests',
        'USER': 'root',
        'PASSWORD': 'secret',
    },
    'other': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'djangotests_other',
        'USER': 'root',
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
