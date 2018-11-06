import groovy.json.JsonOutput
import com.orientechnologies.orient.core.storage.ORecordDuplicatedException

security.setAnonymousAccess(false)
log.info('Anonymous access disabled')

// Initially nx-god role is not created which maps LDAP group id 500(ou=admins)
rolePresent = false

try {
    nxgod = security.addRole("500","nx-god","Gives every bit of privilege",["nx-all"],["nx-admin"])
} catch (ORecordDuplicatedException e) {
    log.info('Already a role with id 500(ou=admins in LDAP) exists')
}

rolePresent = security.getSecuritySystem().listRoles().name.contains('nx-god')

return JsonOutput.toJson(rolePresent)