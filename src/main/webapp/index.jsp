<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Kavya | DevOps Portfolio</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <style>
    body {
      font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      background: #f4f7fb;
      color: #333;
    }

    header {
      background: linear-gradient(135deg, #004aad, #0073e6);
      color: white;
      padding: 60px 20px;
      text-align: center;
    }

    header h1 {
      margin: 0;
      font-size: 2.5rem;
    }

    header p {
      margin-top: 15px;
      font-size: 1.1rem;
      opacity: 0.9;
    }

    .section {
      max-width: 900px;
      margin: 50px auto;
      padding: 0 20px;
      text-align: center;
    }

    .card {
      background: white;
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 8px 18px rgba(0,0,0,0.08);
    }

    .btn {
      display: inline-block;
      margin-top: 20px;
      padding: 12px 25px;
      background: #004aad;
      color: white;
      text-decoration: none;
      border-radius: 30px;
      transition: 0.3s ease;
      font-weight: 500;
    }

    .btn:hover {
      background: #00337a;
      transform: scale(1.05);
    }

    footer {
      margin-top: 60px;
      padding: 20px;
      background: #222;
      color: white;
      text-align: center;
      font-size: 0.9rem;
    }
  </style>
</head>

<body>

<header>
  <h1>Hi, Welcome to My Portfolio 🚀</h1>
  <p>DevOps Engineer | CI/CD | Kubernetes | Cloud Enthusiast</p>
</header>

<div class="section">
  <div class="card">
    <h2>About Me</h2>
    <p>
      I am passionate about building scalable and automated cloud solutions.
      This project demonstrates a complete CI/CD pipeline using
      Git, Jenkins, Maven, Docker, and Kubernetes deployed on AWS EKS.
    </p>

    <h3>Deployment Time:</h3>
    <p><strong><%= new java.util.Date() %></strong></p>

    <a href="https://www.linkedin.com/in/kavya-r-b2a29417b/"
       target="_blank"
       class="btn">
       Connect with me on LinkedIn
    </a>
  </div>
</div>

<footer>
  © <%= java.time.Year.now() %> Kavya | Built with ❤️ using DevOps
</footer>

</body>
</html>
