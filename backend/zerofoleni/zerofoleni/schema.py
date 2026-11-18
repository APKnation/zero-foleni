import graphene
from graphene_django import DjangoObjectType
from core.models import Bank, Branch, BankService, Teller, BankTicket, BankAppointment, Citizen

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

class CitizenType(DjangoObjectType):
    class Meta:
        model = Citizen
        fields = ("id", "full_name", "phone", "email", "national_id")

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
        if Citizen.objects.filter(phone=phone).exists():
            return RegisterCitizen(citizen=None, success=False, message="Phone already registered")
        citizen = Citizen.objects.create(
            full_name=full_name, phone=phone, email=email,
            national_id=national_id, password=password,
        )
        return RegisterCitizen(citizen=citizen, success=True, message="Registered successfully")

class Mutation(graphene.ObjectType):
    register_citizen = RegisterCitizen.Field()

class Query(graphene.ObjectType):
    hello = graphene.String(default_value="Hello from ZeroFoleni GraphQL")
    all_banks = graphene.List(BankType)
    all_branches = graphene.List(BranchType)
    all_tellers = graphene.List(TellerType)
    all_citizens = graphene.List(CitizenType)

    def resolve_all_banks(self, info):
        return Bank.objects.all()
    def resolve_all_branches(self, info):
        return Branch.objects.all()
    def resolve_all_tellers(self, info):
        return Teller.objects.all()
    def resolve_all_citizens(self, info):
        return Citizen.objects.all()

schema = graphene.Schema(query=Query, mutation=Mutation)
