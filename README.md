# QuizMaster — Oracle/Jakarta MVC examination portal

## Requirements
- Java 17+, Maven, Oracle Database 26ai and SQL Developer
- Tomcat 10.1 (Jakarta Servlet 6)
- Oracle `ojdbc17.jar` downloaded from Oracle (not included)

## Setup
1. In SQL Developer, log into a dedicated application database account and run `database/quiz_portal.sql` ONCE (F5). Do not run as SYS/SYSTEM.
2. Copy `src/main/resources/db.properties.example` to `src/main/resources/db.properties`; set your SERVICE_NAME, username, and password (e.g. `jdbc:oracle:thin:@//localhost:1521/FREEPDB1`).
3. Copy your licensed `ojdbc17.jar` into `src/main/webapp/WEB-INF/lib/ojdbc17.jar`.
4. From this folder run `mvn clean package` (Maven must have network access for first dependency installation).
5. Deploy `target/QuizMaster.war` to Tomcat 10.1 `webapps`, start Tomcat, browse `http://localhost:8080/QuizMaster/`.
6. For VS Code, install Extension Pack for Java and Community Server Connectors, register Tomcat home, and start it using Servers view.

## Demo users
Admin: admin@quiz.com / Admin@12345
Student: rahul@quiz.com / Student@123
Student: priya@quiz.com / Student@123

## Routes
`/login`, `/register`, `/logout`, `/admin/quizzes`, `/admin/questions?quiz=1`, `/admin/results?quiz=1`, `/admin/export?quiz=1`, `/student/dashboard`, `/student/history`.

## Notes and limitations
- Demo salted SHA-256 password scheme is for coursework; production should use Argon2id, BCrypt or PBKDF2 with an appropriate work factor.
- A student can start a quiz only once (UNIQUE constraint). Server rejects submissions later than duration + 5s and marks them EXPIRED. Browser countdown is a convenience only.
- Quiz total marks are assigned as the maximum possible; question marks are normalized to total marks when scoring. Avoid editing/deleting quiz questions after students start; a production system should snapshot questions/versions.
- Random question order is refreshed on page load; for stable exam sequencing use a server-persisted order.
- Keep credentials private. Use HTTPS when not testing on localhost. Add rate limiting, audit logs, deployment hardening, and deeper integration tests for real deployment.
- Delete of a quiz with recorded attempts is prevented by FK constraints, and changes to questions may be prevented by FK constraints.
- SQL schema and Java source are provided; Oracle/Tomcat integration could not be exercised in this environment.
