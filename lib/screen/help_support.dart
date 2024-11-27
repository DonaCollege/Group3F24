import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Track-Wise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'FQA',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Adding FAQs Section
              buildFaqSection(),
              const SizedBox(height: 30),
              const Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Email Support:\ntrackwise@gmail.com',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Call Support:\n+1 121 452 77 ##',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.report, color: Colors.white),
                label: const Text(
                  'Report an issue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.blue, // Button color
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black, // Text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFaqSection() {
    // A list of FAQs
    const faqs = [
      {
        "question":
            "What is the purpose of the Driver Analytics Mobile Application?",
        "answer":
            "The app is designed to replace costly physical monitoring devices with a smartphone-based solution, leveraging sensors and APIs to provide real-time driver analytics, enhance safety, and reduce costs."
      },
      {
        "question": "Who can use this app?",
        "answer":
            "The app is suitable for individual drivers, families, and organizations looking to monitor and improve driving habits. It supports multiple profiles under a single account for family or group usage."
      },
      {
        "question": "How do I create an account?",
        "answer":
            "You can create an account through the registration screen by providing your name, email, and password. Two-factor authentication can be enabled for added security."
      },
      {
        "question": "Can I add multiple profiles to a single account?",
        "answer":
            "Yes, the app supports multiple profiles, making it easy to monitor different drivers within a family or group."
      },
      {
        "question": "What kind of data does the app track?",
        "answer":
            "The app tracks speed, location, phone orientation, trip duration, average speed, time in traffic, and sudden driving events like harsh braking or speeding."
      },
      {
        "question": "Does the app work offline?",
        "answer":
            "Yes, essential features like trip tracking and data storage work offline. The app syncs data when an internet connection is available."
      },
      {
        "question": "How is my data protected?",
        "answer":
            "All sensitive data, including personal and location information, is encrypted during storage and transmission. The app also complies with data privacy regulations like GDPR and CCPA."
      },
      {
        "question": "Can I delete my data?",
        "answer":
            "Yes, you can request to delete your data under the GDPR compliance settings in the app."
      },
    ];

    // FAQ List Widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: faqs.map((faq) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Q: ${faq['question']}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "A: ${faq['answer']}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
