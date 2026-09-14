<?php
// Check for empty fields
if(empty($_POST['name'])  		||
   empty($_POST['email']) 		||
   empty($_POST['phone']) 		||
   empty($_POST['message'])	||
   !filter_var($_POST['email'],FILTER_VALIDATE_EMAIL))
   {
	echo "No arguments Provided!";
	return false;
   }

// Sanitize all input to prevent header injection and XSS
$name = htmlspecialchars(trim($_POST['name']), ENT_QUOTES, 'UTF-8');
$email_address = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
$phone = htmlspecialchars(trim($_POST['phone']), ENT_QUOTES, 'UTF-8');
$message = htmlspecialchars(trim($_POST['message']), ENT_QUOTES, 'UTF-8');

// Prevent header injection: strip CRLF from header fields
$safe_email = str_replace(array("\r", "\n"), '', $email_address);
$safe_name = str_replace(array("\r", "\n"), '', $name);

// Create the email and send the message
$to = 'parker.tichko@gmail.com'; // Add your email address inbetween the '' replacing yourname@yourdomain.com - This is where the form will send a message to.
$email_subject = "Website Contact Form:  $safe_name";
$email_body = "You have received a new message from your website contact form.\n\n"."Here are the details:\n\nName: $name\n\nEmail: $email_address\n\nPhone: $phone\n\nMessage:\n$message";
$headers = "From: noreply@gmail.com\r\n"; // This is the email address the generated message will be from. We recommend using something like noreply@yourdomain.com.
$headers .= "Reply-To: $safe_email\r\n";
mail($to,$email_subject,$email_body,$headers);
return true;
?>