# 🚀 CodeTrain API

A powerful competitive programming platform API built with Ruby on Rails that provides secure code execution, real-time testing, and contest management features.

<div align="center">
  <img src="./demo.gif" alt="CodeTrain API Demo" width="1280"/>
</div>

## 📋 Table of Contents

- [🌟 Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🔧 Tech Stack](#-tech-stack)
- [🚀 Quick Start](#-quick-start)
- [📦 Installation](#-installation)
- [🔧 Configuration](#-configuration)
- [🔗 API Endpoints](#-api-endpoints)
- [🏃‍♂️ Code Execution Flow](#️-code-execution-flow)
- [🐳 Docker Setup](#-docker-setup)
- [🧪 Testing](#-testing)
- [📊 Database Schema](#-database-schema)
- [🤝 Contributing](#-contributing)

## 🌟 Features

### 🎯 Core Features
- **Multi-language Support**: Python, JavaScript, C++, Go, Java, Ruby, PHP
- **Real-time Code Execution**: Secure sandboxed execution with Docker
- **Live Progress Updates**: WebSocket-based real-time feedback
- **Contest Management**: Timed contests with leaderboards
- **Organization Support**: Multi-tenant architecture for educational institutions
- **Role-based Access Control**: Students, teachers, and admin roles
- **Test Case Management**: Automated testing with custom test cases

### 🔒 Security Features
- **Sandboxed Execution**: Each code submission runs in isolated Docker containers
- **Memory & Time Limits**: Configurable resource constraints
- **Authentication**: JWT-based authentication with refresh tokens
- **Authorization**: Role-based permissions with CanCanCan

### 📊 Scoring & Analytics
- **Partial Scoring**: Points awarded based on test cases passed
- **Performance Tracking**: Track user progress over time
- **Contest Results**: Automated leaderboards and rankings

## 🏗️ Architecture

### System Overview

The CodeTrain API follows a microservices-inspired architecture with clear separation of concerns:

- **API Layer**: RESTful endpoints with real-time WebSocket support
- **Business Logic**: Service objects and background jobs
- **Data Layer**: PostgreSQL with Redis for caching and queuing
- **Execution Layer**: Isolated Docker containers for code execution
- **Security Layer**: Multi-layered security with sandboxing and resource limits

### Code Execution Flow

```mermaid
sequenceDiagram
    participant User
    participant Frontend
    participant API
    participant ProcessJob
    participant Docker
    participant WebSocket
    
    User->>Frontend: Submit Code Solution
    Frontend->>API: POST /api/v1/attempts
    API->>API: Create Attempt (status: pending)
    API->>ProcessJob: Queue ProcessAttemptJob
    API-->>Frontend: Return Attempt ID
    Frontend->>WebSocket: Subscribe to attempt updates
    
    ProcessJob->>Docker: Create Container
    ProcessJob->>ProcessJob: Update status to "running"
    ProcessJob->>WebSocket: Broadcast status update
    WebSocket-->>Frontend: Status: "Running"
    
    loop For each test case
        ProcessJob->>Docker: Set test input
        ProcessJob->>Docker: Execute user code
        Docker-->>ProcessJob: Return output
        ProcessJob->>ProcessJob: Compare with expected output
        alt Test passes
            ProcessJob->>ProcessJob: Update score
        else Test fails
            ProcessJob->>ProcessJob: Set failure reason
            ProcessJob->>ProcessJob: Break loop
        end
        ProcessJob->>WebSocket: Broadcast progress
        WebSocket-->>Frontend: Progress update
    end
    
    ProcessJob->>Docker: Cleanup container
    ProcessJob->>ProcessJob: Set final status
    ProcessJob->>WebSocket: Broadcast final result
    WebSocket-->>Frontend: Final result
    Frontend-->>User: Show results
```

## 🔧 Tech Stack

### Backend
- **Framework**: Ruby on Rails 7.1.3
- **Language**: Ruby 3.3.1
- **Database**: PostgreSQL 13+
- **Cache/Queue**: Redis
- **Background Jobs**: Sidekiq
- **Authentication**: Devise
- **Authorization**: CanCanCan + Rolify
- **Serialization**: Active Model Serializers
- **WebSockets**: ActionCable

### Infrastructure
- **Containerization**: Docker
- **Code Execution**: Docker containers with language-specific environments
- **Web Server**: Puma
- **CORS**: Rack-CORS

### Supported Programming Languages
- 🐍 Python 3
- 🟨 JavaScript (Node.js)
- ⚡ C++
- 🔷 Go
- ☕ Java
- 💎 Ruby
- 🐘 PHP

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git

### 1. Clone the Repository
```bash
git clone <repository-url>
cd codetrain-api
```

### 2. Start with Docker Compose
```bash
# Build and start all services
docker-compose up --build

# The API will be available at http://localhost:3000
```

### 3. Setup Database
```bash
# In another terminal
docker-compose exec web rails db:create db:migrate db:seed
```

### 4. Build Compiler Images
```bash
# Build all language-specific Docker images
docker-compose exec web rake create_images
```

### 5. Test the Setup
```bash
curl http://localhost:3000/up
# Should return 200 OK
```

## 📦 Installation

### Local Development Setup

#### 1. System Requirements
```bash
# Ruby 3.3.1
rbenv install 3.3.1
rbenv global 3.3.1

# PostgreSQL
brew install postgresql
brew services start postgresql

# Redis
brew install redis
brew services start redis

# Docker
# Install Docker Desktop from https://docker.com
```

#### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Create and setup database
rails db:create db:migrate db:seed
```

#### 3. Environment Configuration
```bash
# Copy environment file
cp .env.example .env

# Edit .env with your configuration
# DATABASE_URL=postgresql://username:password@localhost:5432/codetrain_api_development
# REDIS_URL=redis://localhost:6379/0
```

#### 4. Build Compiler Images
```bash
# Build Docker images for code execution
cd docker/compilers
docker-compose build
cd ../..

# Or use the rake task
rake create_images
```

#### 5. Start Services
```bash
# Start Rails server
rails server

# Start Sidekiq (in another terminal)
bundle exec sidekiq

# Start Redis (if not using system service)
redis-server
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | - |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379/0` |
| `RAILS_ENV` | Rails environment | `development` |
| `SECRET_KEY_BASE` | Rails secret key | Auto-generated |

### Database Configuration
```yaml
# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: codetrain_api_development
  url: <%= ENV['DATABASE_URL'] %>
```

### Redis Configuration
```yaml
# config/cable.yml
development:
  adapter: redis
  url: redis://localhost:6379/1

# config/sidekiq.yml
:queues:
  - default
:max_retries: 3
```

## 🔗 API Endpoints

### Authentication
```bash
# Register
POST /users/sign_up
{
  "user": {
    "login": "username",
    "password": "password",
    "full_name": "John Doe"
  }
}

# Login
POST /users/sign_in
{
  "user": {
    "login": "username",
    "password": "password"
  }
}

# Get current user
GET /users/me
```

### Problems
```bash
# List problems (with pagination, sorting, filtering)
GET /api/v1/problems?page=1&sort_by=complexity&sort_order=asc&tag_ids=1,2

# Get specific problem
GET /api/v1/problems/:id

# Create problem (admin only)
POST /api/v1/problems
{
  "problem": {
    "title": "Two Sum",
    "description": "Find two numbers that add up to target",
    "complexity": 2,
    "tag_ids": [1, 2]
  }
}

# Get user's attempts for a problem
GET /api/v1/problems/:id/attempts?contest_id=1
```

### Code Submission
```bash
# Submit code
POST /api/v1/attempts
{
  "attempt": {
    "code": "def solution():\n    return 42",
    "problem_id": 1,
    "language_id": 1,
    "contest_id": 1  # optional
  }
}

# Get attempt details
GET /api/v1/attempts/:id

# List attempts
GET /api/v1/attempts
```

### Contests
```bash
# List contests
GET /api/v1/contests

# Get contest details
GET /api/v1/contests/:id

# Get contest problems
GET /api/v1/contests/:id/problems

# Get contest results
GET /api/v1/contests/:id/results
```

### Organizations
```bash
# List organizations
GET /api/v1/organizations

# Get organization details
GET /api/v1/organizations/:id

# Get teachers in organization
GET /api/v1/organizations/:id/teachers

# Get students in organization
GET /api/v1/organizations/:id/students

# Get organization contests
GET /api/v1/organizations/:id/contests
```

### WebSocket Connections
```javascript
// Subscribe to attempt updates
const cable = ActionCable.createConsumer('ws://localhost:3000/cable');
const subscription = cable.subscriptions.create(
  { channel: 'AttemptsChannel', problem_id: 1, user_id: 1 },
  {
    received: function(data) {
      console.log('Attempt update:', data);
    }
  }
);
```

## 🏃‍♂️ Code Execution Flow

### 1. Submission Process
1. User submits code via API
2. `Attempt` record created with status "pending"
3. `ProcessAttemptJob` queued via Sidekiq
4. Job starts execution and updates status to "running"

### 2. Container Creation
1. Docker container created with 128MB memory limit
2. Language-specific environment loaded
3. User code written to container filesystem

### 3. Test Execution
1. For each test case:
   - Input data written to container
   - User code executed with time/memory limits
   - Output captured and compared with expected result
   - Score updated based on passing tests
   - Progress broadcast via WebSocket

### 4. Result Processing
1. Final status determined (passed/failed/error)
2. Container cleaned up
3. Final result broadcast to user
4. Attempt record updated with final score and status

### Execution Statuses
- **pending**: Initial state, waiting for execution
- **running**: Currently being executed
- **passed**: All test cases passed
- **wrong_answer**: Some test cases failed
- **time_limit**: Execution exceeded time limit
- **memory_limit**: Execution exceeded memory limit
- **runtime_error**: Code crashed during execution
- **compilation_error**: Code failed to compile/parse

## 🐳 Docker Setup

### Compiler Images
The system uses separate Docker images for each programming language:

```bash
# Python environment
docker/compilers/Dockerfile.python

# JavaScript environment  
docker/compilers/Dockerfile.node

# C++ environment
docker/compilers/Dockerfile.cpp

# Go environment
docker/compilers/Dockerfile.go

# Java environment
docker/compilers/Dockerfile.java

# Ruby environment
docker/compilers/Dockerfile.ruby

# PHP environment
docker/compilers/Dockerfile.php
```

### Building Images
```bash
# Build all compiler images
cd docker/compilers
docker-compose build

# Or use the rake task
rake create_images

# Build specific language
docker build -f Dockerfile.python -t python_compiler .
```

### Container Security
- **Memory Limits**: 128MB + language-specific overhead
- **No Network Access**: Containers run in isolated network
- **Temporary Filesystem**: All files deleted after execution
- **Time Limits**: Configurable execution timeouts
- **No Persistent Storage**: Containers destroyed after use

## 🧪 Testing

### Running Tests
```bash
# Run all tests
rails test

# Run specific test files
rails test test/models/attempt_test.rb
rails test test/controllers/api/v1/attempts_controller_test.rb

# Run with coverage
COVERAGE=true rails test
```

### Test Categories
- **Model Tests**: Validations, associations, business logic
- **Controller Tests**: API endpoints, authentication, authorization
- **Integration Tests**: Full request/response cycles
- **Channel Tests**: WebSocket functionality

### Example Test
```ruby
# test/models/attempt_test.rb
class AttemptTest < ActiveSupport::TestCase
  test "should create attempt with valid attributes" do
    attempt = Attempt.new(
      code: "print('Hello World')",
      user: users(:student),
      problem: problems(:two_sum),
      language: languages(:python)
    )
    assert attempt.valid?
  end
end
```

## 📊 Database Schema

### Core Entities

#### Users
- Authentication and profile information
- Organization membership
- Role assignments (student/teacher/admin)

#### Problems
- Title, description, complexity level
- Associated test cases and tags
- Scoring configuration

#### Attempts
- User's code submissions
- Execution results and scores
- Contest association (optional)

#### Tests
- Input/output pairs for problems
- Automated validation of solutions

#### Contests
- Timed competitive events
- Problem sets and participant management
- Leaderboard generation

#### Organizations
- Multi-tenant support
- User and contest isolation
- Educational institution management

### Relationships
```sql
-- Users belong to organizations and have roles
users -> organizations (many-to-one)
users -> roles (many-to-many)

-- Problems have tests and tags
problems -> tests (one-to-many)
problems -> tags (many-to-many)

-- Attempts connect users, problems, and languages
attempts -> users (many-to-one)
attempts -> problems (many-to-one) 
attempts -> languages (many-to-one)
attempts -> contests (many-to-one, optional)

-- Contests belong to organizations and have problems/users
contests -> organizations (many-to-one)
contests -> problems (many-to-many)
contests -> users (many-to-many)
```

### Database Migrations
```bash
# Create new migration
rails generate migration AddScoreToAttempts score:float

# Run migrations
rails db:migrate

# Rollback migration
rails db:rollback

# Reset database
rails db:drop db:create db:migrate db:seed
```

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make changes and add tests
4. Run tests: `rails test`
5. Commit changes: `git commit -am 'Add new feature'`
6. Push to branch: `git push origin feature/new-feature`
7. Create Pull Request

### Code Style
- Follow Ruby/Rails conventions
- Use descriptive variable and method names
- Add comments for complex logic
- Maintain test coverage

### Adding New Languages
1. Create Dockerfile in `docker/compilers/`
2. Add compiler class in `app/compilers/`
3. Add language record to database
4. Update documentation

Example:
```ruby
# app/compilers/rust_compiler.rb
class RustCompiler < Compiler
  EXTRA_MEMORY = 10

  private

  def source_setup(container, code)
    container.store_file('main.rs', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'rustc main.rs && ./main', extra_memory: EXTRA_MEMORY)
  end
end
```

### Security Considerations
- Never execute user code directly on the host
- Always use Docker containers for code execution
- Validate and sanitize all user inputs
- Implement proper authentication and authorization
- Monitor resource usage and set appropriate limits

---

## 📞 Support

For questions or issues:
- Open an issue on GitHub
- Check existing documentation
- Review test files for usage examples

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ for competitive programming and education**