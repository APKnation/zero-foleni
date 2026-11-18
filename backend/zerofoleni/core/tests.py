from django.test import TestCase
from graphene.test import Client
from zerofoleni.schema import schema
from core.models import Bank, Branch, BankService, Citizen, Institution

class GraphQLApiTests(TestCase):
    def setUp(self):
        self.client = Client(schema)
        self.bank = Bank.objects.create(name="NMB Bank", code="NMB")
        self.branch = Branch.objects.create(bank=self.bank, name="City Centre", location="Dar")
        self.service = BankService.objects.create(branch=self.branch, name="Cash Deposit")
        self.inst = Institution.objects.create(name="Muhimbili", type="hospital", location="Upanga")

    def test_hello_query(self):
        executed = self.client.execute('{ hello }')
        self.assertEqual(executed['data']['hello'], "Hello from ZeroFoleni GraphQL")

    def test_all_banks_query(self):
        executed = self.client.execute('{ allBanks { id name code } }')
        banks = executed['data']['allBanks']
        self.assertTrue(len(banks) >= 1)
        self.assertEqual(banks[0]['name'], "NMB Bank")

    def test_register_and_login_citizen(self):
        # Register
        reg_mutation = '''
            mutation {
                registerCitizen(
                    fullName: "Juma Hamisi",
                    phone: "0712345678",
                    password: "SecretPassword123",
                    email: "juma@example.com"
                ) {
                    success
                    message
                    citizen {
                        id
                        fullName
                        phone
                    }
                }
            }
        '''
        res = self.client.execute(reg_mutation)
        self.assertTrue(res['data']['registerCitizen']['success'])
        self.assertEqual(res['data']['registerCitizen']['citizen']['fullName'], "Juma Hamisi")

        # Duplicate phone should fail
        res2 = self.client.execute(reg_mutation)
        self.assertFalse(res2['data']['registerCitizen']['success'])

        # Login
        login_mutation = '''
            mutation {
                loginCitizen(phone: "0712345678", password: "SecretPassword123") {
                    success
                    message
                    token
                    citizen {
                        id
                        fullName
                    }
                }
            }
        '''
        login_res = self.client.execute(login_mutation)
        self.assertTrue(login_res['data']['loginCitizen']['success'])
        self.assertNotEqual(login_res['data']['loginCitizen']['token'], "")

        # Wrong password
        bad_login = '''
            mutation {
                loginCitizen(phone: "0712345678", password: "WrongPassword") {
                    success
                    message
                }
            }
        '''
        bad_res = self.client.execute(bad_login)
        self.assertFalse(bad_res['data']['loginCitizen']['success'])

    def test_create_bank_ticket(self):
        mutation = f'''
            mutation {{
                createBankTicket(
                    bankId: "{self.bank.id}",
                    branchId: "{self.branch.id}",
                    serviceId: "{self.service.id}"
                ) {{
                    success
                    message
                    ticket {{
                        id
                        number
                        position
                        status
                    }}
                }}
            }}
        '''
        res = self.client.execute(mutation)
        self.assertTrue(res['data']['createBankTicket']['success'])
        ticket = res['data']['createBankTicket']['ticket']
        self.assertIsNotNone(ticket['number'])
        self.assertEqual(ticket['position'], 1)
        self.assertEqual(ticket['status'], 'waiting')

    def test_institutions_query(self):
        query = '{ allInstitutions(type: "hospital") { id name type location } }'
        res = self.client.execute(query)
        insts = res['data']['allInstitutions']
        self.assertEqual(len(insts), 1)
        self.assertEqual(insts[0]['name'], "Muhimbili")
