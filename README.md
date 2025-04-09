# SIH Tools Codebase

This repository contains a collection of tools and applications developed for Smart India Hackathon (SIH). The codebase includes multiple projects focused on sustainability, environmental monitoring, and digital transformation.

## 🌟 Projects

### 1. ESG Post Office
A comprehensive Flutter application for tracking and managing environmental sustainability metrics in post offices. This project aims to help postal services monitor and reduce their carbon footprint through various sustainability initiatives.

#### Features
- **Bill Management**
  - Electricity consumption tracking
  - Water usage monitoring
  - Fuel consumption analytics
  - Solar panel integration

- **Carbon Credits System**
  - Walk and Earn program
  - Public transport usage tracking
  - Real-time carbon footprint calculation
  - CO₂ savings analytics

- **Smart Dashboard**
  - Comprehensive sustainability metrics
  - Real-time monitoring
  - Performance trends
  - Employee and user profiles

### 2. BRSR Dashboard
A web-based dashboard for Business Responsibility and Sustainability Reporting.

### 3. Mini Juris 2.0
Legal documentation and management system.

## 🛠️ Technology Stack

- **Frontend**
  - Flutter (ESG Post Office mobile app)
  - Next.js (BRSR Dashboard)
  - Modern UI/UX principles

- **Backend**
  - Firebase
  - Cloud Firestore
  - Firebase Authentication

- **AI/ML Integration**
  - OpenAI API for document processing
  - Google ML Kit for OCR
  - Image to JSON conversion

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.4.3
- Dart SDK ≥ 3.0.0
- Node.js and npm (for web projects)
- Firebase account
- OpenAI API key (for AI features)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Install dependencies:
```bash
# For ESG Post Office
cd esg_post_office
flutter pub get

# For BRSR Dashboard
cd brsr_dashboard
npm install
```

3. Configure environment variables:
Create a `.env` file in the project root with the following:
```
OPENAI_API_KEY=your_api_key
```

4. Run the applications:
```bash
# For ESG Post Office
flutter run

# For BRSR Dashboard
npm run dev
```

## 📱 Features in Detail

### ESG Post Office App

1. **Authentication**
   - User registration and login
   - Profile management
   - Role-based access control

2. **Bill Management**
   - Upload and process utility bills
   - OCR-powered data extraction
   - Historical data tracking

3. **Carbon Credits**
   - Walk tracking with pedometer
   - Public transport usage rewards
   - Real-time carbon savings calculation

4. **Dashboard**
   - Personal carbon footprint
   - Sustainability metrics
   - Achievement tracking

## 🔒 Security

- Environment variables and sensitive configurations are not tracked in version control
- Firebase security rules implementation
- Secure API key management
- User authentication and authorization

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Smart India Hackathon organization
- Indian Post Office for collaboration
- All contributors and team members 