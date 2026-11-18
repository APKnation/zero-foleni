import graphene
from graphene_django import DjangoObjectType
from django.contrib.auth.hashers import make_password, check_password
import random
from core.models import (
    Bank, Branch, BankService, Teller, BankTicket, BankAppointment,
    Institution, Service, ServiceProvider, Ticket, Appointment, Citizen
)

class BankType(DjangoObjectType):
    class Meta:
        model = Bank
        fields = "__all__"

class BranchType(DjangoObjectType):
    class Meta:
        model = Branch
        fields = "__all__"

class BankServiceType(DjangoObjectType):
    class Meta:
        model = BankService
        fields = "__all__"

class TellerType(DjangoObjectType):
    class Meta:
        model = Teller
        fields = "__all__"

class BankTicketType(DjangoObjectType):
    class Meta:
        model = BankTicket
        fields = "__all__"

class BankAppointmentType(DjangoObjectType):
    class Meta:
        model = BankAppointment
        fields = "__all__"

class InstitutionType(DjangoObjectType):
    class Meta:
        model = Institution
        fields = "__all__"

class ServiceType(DjangoObjectType):
    class Meta:
        model = Service
        fields = "__all__"

class ServiceProviderType(DjangoObjectType):
    class Meta:
        model = ServiceProvider
        fields = "__all__"

class TicketType(DjangoObjectType):
    class Meta:
        model = Ticket
        fields = "__all__"

class AppointmentType(DjangoObjectType):
    class Meta:
        model = Appointment
        fields = "__all__"

class CitizenType(DjangoObjectType):
    class Meta:
        model = Citizen
        fields = ("id", "full_name", "phone", "email", "national_id", "created_at")

# MUTATIONS

class RegisterCitizen(graphene.Mutation):
    class Arguments:
        full_name = graphene.String(required=True)
        phone = graphene.String(required=True)
        email = graphene.String()
        national_id = graphene.String()
        password = graphene.String(required=True)

    citizen = graphene.Field(CitizenType)
    success = graphene.Boolean()
    message = graphene.String()

    def mutate(self, info, full_name, phone, password, email="", national_id=""):
        phone = phone.strip()
        if Citizen.objects.filter(phone=phone).exists():
            return RegisterCitizen(citizen=None, success=False, message="Namba hii ya simu imeshasajiliwa (Phone already registered)")
        
        citizen = Citizen.objects.create(
            full_name=full_name.strip(),
            phone=phone,
            email=email.strip() if email else "",
            national_id=national_id.strip() if national_id else "",
            password=make_password(password),
        )
        return RegisterCitizen(citizen=citizen, success=True, message="Umesajiliwa kikamilifu (Registration successful)")

class LoginCitizen(graphene.Mutation):
    class Arguments:
        phone = graphene.String(required=True)
        password = graphene.String(required=True)

    citizen = graphene.Field(CitizenType)
    success = graphene.Boolean()
    message = graphene.String()
    token = graphene.String()

    def mutate(self, info, phone, password):
        phone = phone.strip()
        citizen = Citizen.objects.filter(phone=phone).first()
        if not citizen:
            citizen = Citizen.objects.filter(email=phone).first()
        
        if not citizen:
            return LoginCitizen(citizen=None, success=False, message="Mtumiaji hajapatikana (User not found)", token="")
        
        pwd_ok = check_password(password, citizen.password) or (password == citizen.password)
        if not pwd_ok:
            return LoginCitizen(citizen=None, success=False, message="Nenosiri sio sahihi (Invalid password)", token="")
        
        token = f"zf-{citizen.id}-{abs(hash(citizen.phone))}"
        return LoginCitizen(citizen=citizen, success=True, message="Umeingia kikamilifu (Login successful)", token=token)

class CreateBankTicket(graphene.Mutation):
    class Arguments:
        bank_id = graphene.ID(required=True)
        branch_id = graphene.ID(required=True)
        service_id = graphene.ID(required=True)
        teller_id = graphene.ID()

    ticket = graphene.Field(BankTicketType)
    success = graphene.Boolean()
    message = graphene.String()

    def mutate(self, info, bank_id, branch_id, service_id, teller_id=None):
        try:
            bank = Bank.objects.get(id=bank_id)
            branch = Branch.objects.get(id=branch_id, bank=bank)
            service = BankService.objects.get(id=service_id, branch=branch)
            teller = Teller.objects.get(id=teller_id, branch=branch) if teller_id else None

            count = BankTicket.objects.count() + 1000
            number = str(count % 9000 + 1000)
            while BankTicket.objects.filter(number=number).exists():
                number = str(random.randint(1000, 9999))

            waiting_count = BankTicket.objects.filter(branch=branch, status='waiting').count()
            position = waiting_count + 1

            ticket = BankTicket.objects.create(
                bank=bank,
                branch=branch,
                service=service,
                teller=teller,
                number=number,
                position=position,
                status='waiting'
            )
            return CreateBankTicket(ticket=ticket, success=True, message="Tiketi imetolewa kikamilifu (Ticket generated successfully)")
        except Exception as e:
            return CreateBankTicket(ticket=None, success=False, message=str(e))

class BookBankAppointment(graphene.Mutation):
    class Arguments:
        bank_id = graphene.ID(required=True)
        branch_id = graphene.ID(required=True)
        service_id = graphene.ID(required=True)
        date = graphene.String(required=True)
        time = graphene.String(required=True)

    appointment = graphene.Field(BankAppointmentType)
    success = graphene.Boolean()
    message = graphene.String()

    def mutate(self, info, bank_id, branch_id, service_id, date, time):
        try:
            bank = Bank.objects.get(id=bank_id)
            branch = Branch.objects.get(id=branch_id, bank=bank)
            service = BankService.objects.get(id=service_id, branch=branch)

            appt = BankAppointment.objects.create(
                bank=bank,
                branch=branch,
                service=service,
                date=date,
                time=time,
                status='booked'
            )
            return BookBankAppointment(appointment=appt, success=True, message="Miadi imewekwa kikamilifu (Appointment booked successfully)")
        except Exception as e:
            return BookBankAppointment(appointment=None, success=False, message=str(e))

class CreateInstitutionTicket(graphene.Mutation):
    class Arguments:
        institution_id = graphene.ID(required=True)
        service_id = graphene.ID(required=True)
        provider_id = graphene.ID()

    ticket = graphene.Field(TicketType)
    success = graphene.Boolean()
    message = graphene.String()

    def mutate(self, info, institution_id, service_id, provider_id=None):
        try:
            institution = Institution.objects.get(id=institution_id)
            service = Service.objects.get(id=service_id, institution=institution)
            provider = ServiceProvider.objects.get(id=provider_id, service=service) if provider_id else None

            count = Ticket.objects.count() + 1000
            number = str(count % 9000 + 1000)
            while Ticket.objects.filter(number=number).exists():
                number = str(random.randint(1000, 9999))

            waiting_count = Ticket.objects.filter(institution=institution, status='waiting').count()
            position = waiting_count + 1

            ticket = Ticket.objects.create(
                institution=institution,
                service=service,
                provider=provider,
                number=number,
                position=position,
                status='waiting'
            )
            return CreateInstitutionTicket(ticket=ticket, success=True, message="Tiketi imetolewa kikamilifu")
        except Exception as e:
            return CreateInstitutionTicket(ticket=None, success=False, message=str(e))

class Mutation(graphene.ObjectType):
    register_citizen = RegisterCitizen.Field()
    login_citizen = LoginCitizen.Field()
    create_bank_ticket = CreateBankTicket.Field()
    book_bank_appointment = BookBankAppointment.Field()
    create_institution_ticket = CreateInstitutionTicket.Field()

class Query(graphene.ObjectType):
    hello = graphene.String(default_value="Hello from ZeroFoleni GraphQL")
    
    # Banks
    all_banks = graphene.List(BankType)
    bank = graphene.Field(BankType, id=graphene.ID(required=True))
    branches = graphene.List(BranchType, bank_id=graphene.ID())
    bank_services = graphene.List(BankServiceType, branch_id=graphene.ID())
    tellers = graphene.List(TellerType, branch_id=graphene.ID())
    bank_ticket = graphene.Field(BankTicketType, number=graphene.String(required=True))

    # Institutions
    all_institutions = graphene.List(InstitutionType, type=graphene.String())
    institution = graphene.Field(InstitutionType, id=graphene.ID(required=True))
    services = graphene.List(ServiceType, institution_id=graphene.ID())
    service_providers = graphene.List(ServiceProviderType, service_id=graphene.ID())
    ticket = graphene.Field(TicketType, number=graphene.String(required=True))

    # Citizens
    all_citizens = graphene.List(CitizenType)
    citizen = graphene.Field(CitizenType, id=graphene.ID(), phone=graphene.String())

    def resolve_all_banks(self, info):
        return Bank.objects.all().order_by('name')

    def resolve_bank(self, info, id):
        try:
            return Bank.objects.get(id=id)
        except Bank.DoesNotExist:
            return None

    def resolve_branches(self, info, bank_id=None):
        if bank_id:
            return Branch.objects.filter(bank_id=bank_id).order_by('name')
        return Branch.objects.all()

    def resolve_bank_services(self, info, branch_id=None):
        if branch_id:
            return BankService.objects.filter(branch_id=branch_id).order_by('name')
        return BankService.objects.all()

    def resolve_tellers(self, info, branch_id=None):
        if branch_id:
            return Teller.objects.filter(branch_id=branch_id).order_by('name')
        return Teller.objects.all()

    def resolve_bank_ticket(self, info, number):
        return BankTicket.objects.filter(number=number).first()

    def resolve_all_institutions(self, info, type=None):
        qs = Institution.objects.all()
        if type:
            qs = qs.filter(type=type.lower())
        return qs.order_by('name')

    def resolve_institution(self, info, id):
        try:
            return Institution.objects.get(id=id)
        except Institution.DoesNotExist:
            return None

    def resolve_services(self, info, institution_id=None):
        if institution_id:
            return Service.objects.filter(institution_id=institution_id).order_by('name')
        return Service.objects.all()

    def resolve_service_providers(self, info, service_id=None):
        if service_id:
            return ServiceProvider.objects.filter(service_id=service_id).order_by('name')
        return ServiceProvider.objects.all()

    def resolve_ticket(self, info, number):
        return Ticket.objects.filter(number=number).first()

    def resolve_all_citizens(self, info):
        return Citizen.objects.all()

    def resolve_citizen(self, info, id=None, phone=None):
        if id:
            return Citizen.objects.filter(id=id).first()
        if phone:
            return Citizen.objects.filter(phone=phone).first()
        return None

schema = graphene.Schema(query=Query, mutation=Mutation)
