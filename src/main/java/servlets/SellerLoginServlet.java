package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.bittercode.constant.BookStoreConstants;
import com.bittercode.constant.db.UsersDBConstants;
import com.bittercode.model.StoreException;
import com.bittercode.model.User;
import com.bittercode.model.UserRole;
import com.bittercode.service.UserService;
import com.bittercode.service.impl.UserServiceImpl;

public class SellerLoginServlet extends HttpServlet {

    UserService userService = new UserServiceImpl();

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        PrintWriter pw = res.getWriter();
        res.setContentType(BookStoreConstants.CONTENT_TYPE_TEXT_HTML);
        String uName = req.getParameter(UsersDBConstants.COLUMN_USERNAME);
        String pWord = req.getParameter(UsersDBConstants.COLUMN_PASSWORD);
        try {
            User user = userService.login(UserRole.SELLER, uName, pWord, req.getSession());
            if (user != null) {
                pw.println("<!DOCTYPE html>");
                pw.println("<html><body>");
                pw.println("<h2>Welcome " + user.getFirstName() + "!</h2>");
                pw.println("<p>Seller login successful.</p>");
                pw.println("</body></html>");
            } else {
                pw.println("<!DOCTYPE html>");
                pw.println("<html><body>");
                pw.println("<h2>Login failed</h2>");
                pw.println("<p>Incorrect username or password.</p>");
                pw.println("</body></html>");
            }

        } catch (StoreException e) {
            e.printStackTrace();
            pw.println("<!DOCTYPE html>");
            pw.println("<html><body>");
            pw.println("<h2>Login error</h2>");
            pw.println("<p>" + e.getMessage() + "</p>");
            pw.println("</body></html>");
        }
    }
}