# Micro-Influencer Marketplace & Management Platform

The Micro-Influencer Marketplace & Management Platform is designed to bridge the gap between brands and micro-influencers with 10k-100k followers. This platform streamlines the process of influencer marketing campaigns, focusing on the unique needs of the micro-influencer market.

## Features

- **Comprehensive Influencer Profiles**: Detailed portfolios showcasing influencer metrics and past work.
- **Advanced Matching Algorithm**: Optimal influencer-brand pairing based on various factors.
- **Intuitive Brand Campaign Management**: Tools for brands to create, manage, and track campaigns.
- **Detailed Performance Analytics**: Real-time insights into campaign performance and ROI.
- **Cross-Platform Compatibility**: Developed using Flutter for a seamless experience across devices.

## Technology Stack

- **Backend**: Python, Django, Django REST Framework
- **Frontend**: Flutter, Dart
- **Database**: MySQL
- **Caching**: Redis

## Getting Started

### Prerequisites

- Python (3.8 or later)
- Flutter SDK (latest stable version)
- MySQL (8.0 or later)
- Redis (6.0 or later)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/Influncer_hub.git
   ```

2. Navigate to the project directory:
   ```
   cd Influncer_hub
   ```

3. Set up the backend:
   ```
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   pip install -r requirements.txt
   python manage.py migrate
   ```

4. Set up the frontend:
   ```
   cd ../frontend
   flutter pub get
   ```

5. Set up environment variables:
   Create a `.env` file in the backend directory and add the following:
   ```
   SECRET_KEY=your_django_secret_key
   DEBUG=True
   DATABASE_URL=mysql://user:password@localhost/dbname
   REDIS_URL=redis://localhost:6379
   ```

6. Start the development servers:
   For the backend:
   ```
   python manage.py runserver
   ```
   For the frontend:
   ```
   flutter run
   ```

## Development Approach

This project is developed using the following methodologies and focuses:

- Agile development practices adapted for a solo development environment
- Cross-platform development using Flutter for the frontend
- Robust and scalable backend architecture with Django and Django REST Framework
- Implementation of a sophisticated recommendation system for influencer-brand matching
- Integration of essential third-party services for enhanced functionality

## Contributing

We welcome contributions to the Micro-Influencer Marketplace & Management Platform! Please see our [CONTRIBUTING.md](contributing.md) file for details on how to get started.

## License

This project is licensed under the MIT License - see the [LICENSE.md](license.md) file for details.

## Author

Khaled Abdellaty


## Contact

For any questions or concerns, please contact me at kabdellaty@gmail.com.

---

Thank you for your interest in the Micro-Influencer Marketplace & Management Platform! We're excited to revolutionize the micro-influencer marketing landscape with this innovative solution.
