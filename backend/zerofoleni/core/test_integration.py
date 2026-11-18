import json
from django.test import Client, TestCase

class FrontendBackendIntegrationTest(TestCase):
    def setUp(self):
        self.client = Client()

    def test_end_to_end_graphql_communication(self):
        print("\n--- Running End-to-End Frontend to Backend Communication Test ---")

        # 1. Health check
        res = self.client.post(
            '/graphql/',
            data=json.dumps({'query': '{ hello }'}),
            content_type='application/json',
            HTTP_ORIGIN='http://localhost:3000'
        )
        self.assertEqual(res.status_code, 200)
        data = res.json()
        self.assertEqual(data['data']['hello'], "Hello from ZeroFoleni GraphQL")
        print("  [PASS] 1. Backend Health Check OK: " + data['data']['hello'])

        # 2. Query banks
        res = self.client.post(
            '/graphql/',
            data=json.dumps({'query': '{ allBanks { id name code } }'}),
            content_type='application/json'
        )
        self.assertEqual(res.status_code, 200)
        data = res.json()
        self.assertIn('data', data)
        print("  [PASS] 2. Query All Banks OK")

        # 3. Citizen Registration
        phone = "0799887766"
        reg_query = f'''
            mutation {{
                registerCitizen(
                    fullName: "Baraka Mwangi",
                    phone: "{phone}",
                    password: "Password123",
                    email: "baraka@example.com",
                    nationalId: "19900101-12345"
                ) {{
                    success
                    message
                    citizen {{
                        id
                        fullName
                        phone
                    }}
                }}
            }}
        '''
        res = self.client.post('/graphql/', data=json.dumps({'query': reg_query}), content_type='application/json')
        self.assertEqual(res.status_code, 200)
        reg_data = res.json()['data']['registerCitizen']
        self.assertTrue(reg_data['success'])
        print(f"  [PASS] 3. Citizen Registration OK: {reg_data['message']}")

        # 4. Citizen Login
        login_query = f'''
            mutation {{
                loginCitizen(phone: "{phone}", password: "Password123") {{
                    success
                    message
                    token
                    citizen {{
                        id
                        fullName
                    }}
                }}
            }}
        '''
        res = self.client.post('/graphql/', data=json.dumps({'query': login_query}), content_type='application/json')
        self.assertEqual(res.status_code, 200)
        login_data = res.json()['data']['loginCitizen']
        self.assertTrue(login_data['success'])
        self.assertTrue(len(login_data['token']) > 0)
        print(f"  [PASS] 4. Citizen Login OK: Token={login_data['token']}")

        # 5. Query Institutions
        inst_query = '{ allInstitutions(type: "hospital") { id name location } }'
        res = self.client.post('/graphql/', data=json.dumps({'query': inst_query}), content_type='application/json')
        self.assertEqual(res.status_code, 200)
        inst_data = res.json()['data']['allInstitutions']
        print(f"  [PASS] 5. Query Institutions OK: Found {len(inst_data)} hospitals")

        print("--- All Communication Tests Passed Successfully! ---\n")
