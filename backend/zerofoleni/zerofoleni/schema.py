import graphene
from graphene_django import DjangoObjectType
from core.models import Bank, Branch, BankService, Teller, BankTicket, BankAppointment

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

class Query(graphene.ObjectType):
    hello = graphene.String(default_value="Hello from ZeroFoleni GraphQL")
    all_banks = graphene.List(BankType)
    all_branches = graphene.List(BranchType)
    all_tellers = graphene.List(TellerType)

    def resolve_all_banks(self, info):
        return Bank.objects.all()
    def resolve_all_branches(self, info):
        return Branch.objects.all()
    def resolve_all_tellers(self, info):
        return Teller.objects.all()

schema = graphene.Schema(query=Query)
