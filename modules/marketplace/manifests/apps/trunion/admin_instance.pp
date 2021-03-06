# define admin instance for trunion.
define marketplace::apps::trunion::admin_instance(
  $app_name,
  $certfile,
  $chainfile,
  $cluster,
  $domain,
  $env,
  $keyfile,
  $ssh_key,
  $update_ref,
  $dev = false,
  $ca_certfile = '',
  $cert_validity_lifetime = '3650',
  $dnbase_organization = 'Mozilla',
  $dnbase_organizational_unit = 'Mozilla Addons Dev',
  $permitted_issuers = '',
  $pyrepo = 'https://pyrepo.addons.mozilla.org/',
  $uwsgi = 'receipt-signer',
  $we_are_signing = 'apps',
) {
  $project_dir = $name
  $installed_dir = regsubst($project_dir, 'src', 'www')
  $ssl_dir = "${installed_dir}/current/ssl"
  $syslog_name = $app_name

  git::clone {
    "${project_dir}/trunion":
      repo => 'https://github.com/mozilla/trunion.git',

  }

  if $we_are_signing == 'addons' {
    file {
      "${project_dir}/trunion/production.ini":
        require => Git::Clone["${project_dir}/trunion"],
        content => template('marketplace/apps/trunion/admin/production.addons.ini');
    }
  }
  else {
    file {
      "${project_dir}/trunion/production.ini":
        require => Git::Clone["${project_dir}/trunion"],
        content => template('marketplace/apps/trunion/admin/production.ini');
    }
  }

  file {
    "${project_dir}/trunion/deploysettings.py":
      require => Git::Clone["${project_dir}/trunion"],
      content => template('marketplace/apps/trunion/deploysettings.py');
  }
}
