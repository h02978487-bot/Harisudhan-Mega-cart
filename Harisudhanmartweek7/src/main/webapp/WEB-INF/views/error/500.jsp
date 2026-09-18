<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head><title>Something Went Wrong</title></head>
<body>
    <h1>500 — Something Went Wrong</h1>
    <p>An unexpected error occurred. Please try again later.</p>
    <!--
      Intentionally no stack trace, exception message, or SQL text here —
      Section 9 checklist: "Error pages do not expose stack traces."
      Log the real exception server-side via SLF4J/Logback instead
      (see request-id/MDC note in Section 18).
    -->
</body>
</html>
