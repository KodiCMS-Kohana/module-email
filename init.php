<?php defined('SYSPATH') or die('No direct script access.');

Observer::observe('modules::after_load', function() {
	if (IS_INSTALLED AND ACL::check('system.email.settings'))
	{
		Observer::observe('view_setting_plugins', function() {
			echo View::factory('email/settings', array(
				'settings' => Config::get('email'),
				'drivers' => Config::get('email', 'drivers', array()),
			));
		});

		Observer::observe('validation_settings', function( $validation, $filter, $settings) {
			$validation
				->rule('email.default', 'email')
				->rule('email.default', 'not_empty')
				->rule('email.driver', 'in_array', array(':value', array_keys(Config::get('email', 'drivers', array()))))
				->label('email.default', 'Default email address')
				->label('email.driver', 'SMTP Driver');
			
			switch (Arr::path($settings, 'email.driver'))
			{
				case 'sendmail':
					$validation
						->rule('email.options', 'not_empty')
						->label('email.options', 'Executable path');
					break;
				case 'smtp':
					$validation
						->rule('email.options.hostname', 'not_empty')
						->rule('email.options.port', 'not_empty')
						->rule('email.options.port', 'numeric')
						->label('email.options.port', 'SMTP Port')
						->label('email.options.hostname', 'SMTP host');
					break;
			}
		});
	}

	Route::set( 'email_controllers', ADMIN_DIR_NAME.'/email/<controller>(/<action>(/<id>))')
		->defaults( array(
			'action' => 'index',
			'directory' => 'email'
		));
});

if (ACL::check('email.settings'))
{
	if (ACL::check('email.settings'))
	{
		Observer::observe('view_setting_plugins', function() {
			echo View::factory('email/queue/settings');
		});

		Observer::observe('validation_settings', function( $validation, $filter ) {
			$filter
				->rule('email_queue.batch_size', 'intval')
				->rule('email_queue.interval', 'intval')
				->rule('email_queue.max_attempts', 'intval');
		});
	}
}