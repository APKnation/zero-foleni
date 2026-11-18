from django.core.management.base import BaseCommand
from core.models import Bank, Branch, BankService, Teller, Institution, Service, ServiceProvider

class Command(BaseCommand):
    help = 'Seeds initial test data for ZeroFoleni'

    def handle(self, *args, **options):
        self.stdout.write("Seeding ZeroFoleni data...")

        # 1. BANKS
        banks_data = [
            {
                "name": "NMB Bank",
                "code": "NMB",
                "branches": [
                    {"name": "City Centre Branch", "location": "Samora Avenue, Dar es Salaam"},
                    {"name": "Ubungo Branch", "location": "Morogoro Road, Dar es Salaam"},
                    {"name": "Kariakoo Branch", "location": "Msimbazi Street, Dar es Salaam"},
                    {"name": "Mikocheni Branch", "location": "Old Bagamoyo Road, Dar es Salaam"},
                ]
            },
            {
                "name": "CRDB Bank",
                "code": "CRDB",
                "branches": [
                    {"name": "Azikiwe Branch", "location": "City Centre, Dar es Salaam"},
                    {"name": "Oysterbay Branch", "location": "Toure Drive, Dar es Salaam"},
                    {"name": "Kariakoo Branch", "location": "Kariakoo, Dar es Salaam"},
                    {"name": "Mlimani City Branch", "location": "Sam Nujoma, Dar es Salaam"},
                ]
            },
            {
                "name": "NBC Bank",
                "code": "NBC",
                "branches": [
                    {"name": "City Centre Branch", "location": "Sokoine Drive, Dar es Salaam"},
                    {"name": "Samora Branch", "location": "Samora Avenue, Dar es Salaam"},
                ]
            },
            {
                "name": "Stanbic Bank",
                "code": "STANBIC",
                "branches": [
                    {"name": "Stanbic Main Branch", "location": "Ali Hassan Mwinyi Rd, Dar es Salaam"},
                ]
            },
            {
                "name": "Exim Bank",
                "code": "EXIM",
                "branches": [
                    {"name": "Clock Tower Branch", "location": "Maktaba Street, Dar es Salaam"},
                ]
            },
            {
                "name": "Azania Bank",
                "code": "AZANIA",
                "branches": [
                    {"name": "Mawasiliano Branch", "location": "Sam Nujoma Rd, Dar es Salaam"},
                ]
            },
        ]

        default_bank_services = [
            'Account Opening', 'Cash Deposit', 'Cash Withdrawal',
            'Money Transfer', 'Loan Services', 'ATM Card Services', 'Customer Support'
        ]

        default_tellers = ['A. Juma', 'J. Mwamba', 'F. Hassan', 'S. Ally', 'M. Rashid']

        for b_info in banks_data:
            bank, _ = Bank.objects.get_or_create(name=b_info["name"], defaults={"code": b_info["code"]})
            for br_info in b_info["branches"]:
                branch, _ = Branch.objects.get_or_create(
                    bank=bank,
                    name=br_info["name"],
                    defaults={"location": br_info["location"]}
                )
                for s_name in default_bank_services:
                    BankService.objects.get_or_create(branch=branch, name=s_name)
                for t_name in default_tellers[:3]:
                    Teller.objects.get_or_create(branch=branch, name=f"Teller: {t_name}", defaults={"available": True})

        # 2. INSTITUTIONS
        institutions_data = [
            # Hospitals
            {
                "name": "Muhimbili National Hospital",
                "type": "hospital",
                "location": "Kalenga St, Upanga, Dar es Salaam",
                "services": ["Emergency / ICU", "General OPD", "Dental Clinic", "Eye Care", "Pharmacy", "Laboratory"]
            },
            {
                "name": "Aga Khan Hospital",
                "type": "hospital",
                "location": "Ocean Road, Dar es Salaam",
                "services": ["Specialist Consultation", "Cardiology", "Radiology / MRI", "Pediatrics"]
            },
            {
                "name": "Ocean Road Cancer Institute",
                "type": "hospital",
                "location": "Barack Obama Drive, Dar es Salaam",
                "services": ["Screening", "Radiotherapy", "Chemotherapy", "General Oncology"]
            },
            {
                "name": "Amana Regional Hospital",
                "type": "hospital",
                "location": "Ilala, Dar es Salaam",
                "services": ["General OPD", "Maternity Wing", "Minor Surgery", "Child Welfare"]
            },

            # Universities
            {
                "name": "University of Dar es Salaam (UDSM)",
                "type": "university",
                "location": "Mlimani Campus, Dar es Salaam",
                "services": ["Undergraduate Admissions", "Postgraduate Registry", "Fee Clearance & Finance", "Student ID Issuance", "Examination Office"]
            },
            {
                "name": "Ardhi University (ARU)",
                "type": "university",
                "location": "Observation Hill, Dar es Salaam",
                "services": ["Student Registration", "Academic Transcripts", "Fee Clearance"]
            },
            {
                "name": "Mzumbe University",
                "type": "university",
                "location": "Morogoro Campus",
                "services": ["Admissions Office", "Dean of Students", "Bursar / Finance"]
            },
            {
                "name": "Sokoine University of Agriculture (SUA)",
                "type": "university",
                "location": "Morogoro",
                "services": ["Academic Registry", "Admissions", "Student Accommodation"]
            },

            # Government Offices
            {
                "name": "NIDA – National Identification Authority",
                "type": "government",
                "location": "Kibaha / Kivukoni, Dar es Salaam",
                "services": ["NIN Application", "Biometric Registration", "NIDA Card Collection", "Information Update"]
            },
            {
                "name": "BRELA – Business Registrations Agency",
                "type": "government",
                "location": "Co-operative Building, Lumumba St, Dar es Salaam",
                "services": ["Company Registration", "Business Name Search", "Trademark & Patents", "Annual Returns"]
            },
            {
                "name": "TRA – Tanzania Revenue Authority",
                "type": "government",
                "location": "Samora Avenue, Dar es Salaam",
                "services": ["TIN Number Application", "Tax Assessment", "Motor Vehicle Registration", "Customs Clearance"]
            },
            {
                "name": "RITA – Registration Insolvency and Trusteeship Agency",
                "type": "government",
                "location": "Simu St, Dar es Salaam",
                "services": ["Birth Certificate", "Death Certificate", "Marriage Registration", "Trustee Services"]
            },
            {
                "name": "Immigration Department",
                "type": "government",
                "location": "Kivukoni Front, Dar es Salaam",
                "services": ["Passport Application", "Visa Renewal", "Residence Permit"]
            },
            {
                "name": "Local Government Ward Office",
                "type": "government",
                "location": "Local District",
                "services": ["Barua ya Utambulisho (Intro Letter)", "Community Resolution", "Local Business Permits"]
            },
        ]

        for inst_info in institutions_data:
            inst, _ = Institution.objects.get_or_create(
                name=inst_info["name"],
                defaults={"type": inst_info["type"], "location": inst_info["location"]}
            )
            for s_name in inst_info["services"]:
                svc, _ = Service.objects.get_or_create(institution=inst, name=s_name)
                ServiceProvider.objects.get_or_create(service=svc, name=f"Desk Officer ({s_name[:15]})", defaults={"available": True})

        self.stdout.write(self.style.SUCCESS(f"Seed complete! Banks: {Bank.objects.count()}, Institutions: {Institution.objects.count()}"))
