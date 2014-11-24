wp_plugin_counter.sh
--------------------

This script counts how many WordPress plugins your site has, compares the count to the last known count, and notifies you of the results.

This script works best when triggered hourly by cron.

#### Instructions

1. Edit the options in the SETTINGS section to suit your environment.
2. Place the script in your web hosting "home" folder.
3. Add the script to your host's cron tab. If you want it to check hourly, for example, the crontab might look like this:
    ```
    0 * * * * /bin/sh /home3/pretendco/wp_plugin_counter.sh
    ```

The first time the script runs, you'll get a notification that the plugin count has changed. (This is also an excellent opportunity to test whether the SMS alerts are working, if you configured that option.)

#### To Do / Known Issues

- Would be nice to be able to turn off alerts if the count remains unchanged.
- Learn a better way to echo linefeeds.
- Ability to check multiple WP sites on the same host.
- Ability to include multiple recipients.
- Better first run behavior.
- Does not detect CHANGED plugins; only detects ADDED or REMOVED plugins.