from django.db import models

class Institution(models.Model):
    TYPE_CHOICES = [('hospital','Hospital'),('university','University'),('government','Government')]
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    location = models.CharField(max_length=255, blank=True)
    def __str__(self): return self.name

class Service(models.Model):
    institution = models.ForeignKey(Institution, on_delete=models.CASCADE, related_name='services')
    name = models.CharField(max_length=255)
    def __str__(self): return self.name

class ServiceProvider(models.Model):
    service = models.ForeignKey(Service, on_delete=models.CASCADE, related_name='providers')
    name = models.CharField(max_length=255)
    available = models.BooleanField(default=True)
    def __str__(self): return self.name

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

class Bank(models.Model):
    name = models.CharField(max_length=255)
    code = models.CharField(max_length=10, blank=True)
    def __str__(self): return self.name

class Branch(models.Model):
    bank = models.ForeignKey(Bank, on_delete=models.CASCADE, related_name='branches')
    name = models.CharField(max_length=255)
    location = models.CharField(max_length=255, blank=True)
    def __str__(self): return self.name

class BankService(models.Model):
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE, related_name='bank_services')
    name = models.CharField(max_length=255)
    def __str__(self): return self.name

class Teller(models.Model):
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE, related_name='tellers')
    name = models.CharField(max_length=255)
    available = models.BooleanField(default=True)
    def __str__(self): return self.name

class BankTicket(models.Model):
    bank = models.ForeignKey(Bank, on_delete=models.CASCADE)
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE)
    service = models.ForeignKey(BankService, on_delete=models.CASCADE)
    teller = models.ForeignKey(Teller, on_delete=models.SET_NULL, null=True, blank=True)
    number = models.CharField(max_length=4, unique=True)
    position = models.IntegerField(default=1)
    status = models.CharField(max_length=20, default='waiting')
    created_at = models.DateTimeField(auto_now_add=True)

class BankAppointment(models.Model):
    bank = models.ForeignKey(Bank, on_delete=models.CASCADE)
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE)
    service = models.ForeignKey(BankService, on_delete=models.CASCADE)
    date = models.DateField()
    time = models.TimeField()
    status = models.CharField(max_length=20, default='booked')

class Citizen(models.Model):
    full_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=20, unique=True)
    email = models.EmailField(max_length=255, blank=True)
    national_id = models.CharField(max_length=50, blank=True)
    password = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.full_name
