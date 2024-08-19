import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        try (Connection conn = DatabaseUtil.getConnection()) {
            // Check if the email already exists
            String emailCheckQuery = "SELECT COUNT(*) FROM users WHERE email = ?";
            try (PreparedStatement emailCheckStmt = conn.prepareStatement(emailCheckQuery)) {
                emailCheckStmt.setString(1, email);
                ResultSet rs = emailCheckStmt.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    // Redirect to signup page with email exists error message
                    response.sendRedirect("register.html?error=emailexists");
                    return;
                }
            }

            // Check if the username already exists
            String usernameCheckQuery = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement usernameCheckStmt = conn.prepareStatement(usernameCheckQuery)) {
                usernameCheckStmt.setString(1, username);
                ResultSet rs = usernameCheckStmt.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    // Redirect to signup page with username exists error message
                    response.sendRedirect("register.html?error=usernameexists");
                    return;
                }
            }

            // Insert new user if no conflicts
            String insertQuery = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setString(1, username);
                insertStmt.setString(2, password);
                insertStmt.setString(3, email);
                insertStmt.executeUpdate();
                response.sendRedirect("register.html?success=signup");
           
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.html?error=servererror");
        }
    }
}
