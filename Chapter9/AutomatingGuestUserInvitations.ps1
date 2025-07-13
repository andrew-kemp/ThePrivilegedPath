# Required modules
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Import-Module Microsoft.Graph

# Define app credentials
$tenantId = "<your-tenant-id>"
$clientId = "<your-app-client-id>"
$clientSecret = "<your-app-client-secret>"  # Store securely in production

# Define the guest user details
$guestEmail = "external.user@example.com"
$redirectUrl = "https://mycompany.sharepoint.com/sites/PartnerPortal"

# Authenticate using client credentials
Connect-MgGraph -ClientId $clientId -TenantId $tenantId -ClientSecret $clientSecret -Scopes "https://graph.microsoft.com/.default"

# Create the invitation body
$invitation = @{
    invitedUserEmailAddress = $guestEmail
    inviteRedirectUrl       = $redirectUrl
    sendInvitationMessage   = $true
    invitedUserMessageInfo  = @{
        customizedMessageBody = "Welcome! Please use the link below to access our portal."
    }
}

# Send the invitation
New-MgInvitation -BodyParameter $invitation
