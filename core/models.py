from django.db import models

class Institution(models.Model):
    TYPE_CHOICES = [('hospital','Hospital'),('university','University'),('government','Government')]
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    location = models.CharField(max_length=255, blank=True)

    def __str__(self):
        return self.name

class Service(models.Model):
    institution = models.ForeignKey(Institution, on_delete=models.CASCADE, related_name='services')
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name

class ServiceProvider(models.Model):
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name='providers')
    name = models.CharField(max_length=255)
    available = models.BooleanField(default=True)

    def __str__(self):
        return self.name

class Ticket(models.Model):
    institution = models.ForeignKey(Institution, on_delete=models.CASCADE)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    provider = models.ForeignKey(ServiceProvider, on_delete=models.SET_NULL, null=True, blank=True)
    number = models.CharField(max_length=4, unique=True)
    position = models.IntegerField(default=1)
    status = models.CharField(max_length=20, default='waiting')
    created_at = models.DateTimeField(auto_now_add=True)

class Appointment(models.Model):
    institution = models.ForeignKey(Institution, on_delete=models.CASCADE)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    date = models.DateField()
    time = models.TimeField()
    status = models.CharField(max_length=20, default='booked')
