import org.sonatype.nexus.security.user.UserSearchCriteria
import groovy.json.JsonOutput

ldapUsers = security.securitySystem.searchUsers(new UserSearchCriteria(source: 'LDAP'))

return ldapUsers.getAt(0).getRoles().roleId.getAt(0)