use strict;
use warnings;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = '1.4';
%IRSSI = (
    authors     => 'Roni Laukkarinen',
    contact     => 'roni@dude.fi',
    name        => 'ntfy',
    description => 'Send notifications via ntfy when mentioned or receiving a private message, using built-in Irssi highlights.',
    license     => 'GPLv2',
);

# Notification title
my $ntfy_title = 'Irssi Notification';

# Register configuration setting
Irssi::settings_add_str('ntfy', 'ntfy_endpoint', 'https://ntfy.sh/irssi');

# Function to send the notification
sub send_ntfy_notification {
    my ($title, $message) = @_;

    # Retrieve ntfy endpoint setting (full URL endpoint)
    my $ntfy_endpoint = Irssi::settings_get_str('ntfy_endpoint');

    # Send the POST request with plain text message
    system('curl', '-d', $message, $ntfy_endpoint);
}

# Handle highlighted messages using Irssi's built-in highlight functionality
sub highlight_notify {
    my ($dest, $text, $stripped) = @_;

    # Check if the message is highlighted
    if ($dest->{level} & (MSGLEVEL_HILIGHT | MSGLEVEL_MSGS)) {
        my $target = $dest->{target}; # Channel or person
        my $message = "Highlight in $target: $stripped";
        send_ntfy_notification($ntfy_title, $message);
    }
}

# Handle private messages
sub private_message_notify {
    my ($server, $msg, $nick, $address) = @_;
    my $message = "Private message from $nick: $msg";
    send_ntfy_notification($ntfy_title, $message);
}

# Attach handlers to Irssi signals
Irssi::signal_add('print text', 'highlight_notify');
Irssi::signal_add('message private', 'private_message_notify');

Irssi::print("ntfy script loaded. Example usage: /set ntfy_endpoint https://your-custom-ntfy-server/irssi");
