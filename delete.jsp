<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Delete Student Record</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>

    <h1>STUDENT DELETE</h1>

    <% 
        // Get the ID of the student to be deleted
        String id_1 = request.getParameter("id");
        if (id_1 != null) {
            try {
                int id = Integer.parseInt(id_1);
                
                // Connect to the database
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/institute1";
                String username = "root";
                String password = "set-password";
                
                Connection con = DriverManager.getConnection(url, username, password);
                
                // Prepare the delete statement
                String deleteQuery = "DELETE FROM records WHERE id=?";
                PreparedStatement pst = con.prepareStatement(deleteQuery);
                pst.setInt(1, id);
                
                int rowsAffected = pst.executeUpdate();
                
                if (rowsAffected > 0) {
                    // Redirect to a confirmation page or the main page
                    response.sendRedirect("index.jsp?success=true");
                } else {
                    out.println("<script>alert('Failed to delete the record.');</script>");
                }
                
                // Close resources
                pst.close();
                con.close();
            } catch (SQLException e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            }
        } else {
            out.println("<script>alert('No ID provided for deletion.');</script>");
        }
    %>

    <div align="center">
        <h3>Deleting Student Record</h3>
        <p>Are you sure you want to delete this student record?</p>
        <a href="delete.jsp?id=<%= request.getParameter("id") %>" class="btn btn-danger">Delete</a>
        <a href="index.jsp" class="btn btn-primary">Cancel</a>
    </div>

</body>
</html>
