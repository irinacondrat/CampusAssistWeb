<form method="post" action="BookAppointmentServlet">
    <label>Support Type:
        <select name="type">
            <option value="Mental Health">Mental Health</option>
            <option value="Academic">Academic</option>
            <option value="Financial">Financial</option>
        </select>
    </label><br>

    <label>Date: <input type="date" name="date"></label><br>

    <label>Time: <input type="time" name="time"></label><br>

    <label>Details:<br>
        <textarea name="details" rows="5" cols="40"></textarea>
    </label><br>

    <input type="submit" value="Book Appointment">
</form>
