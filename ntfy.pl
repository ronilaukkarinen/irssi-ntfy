use strict;
use warnings;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = '1.3';
%IRSSI = (
    authors     => 'Roni Laukkarinen',
    contact     => 'roni@dude.fi',
    name        => 'ntfy',
    description => 'Send notifications via ntfy when mentioned or receiving a private message.',
    license     => 'GPLv2',
);

# Notification title
my $ntfy_title = 'Irssi Notification';

# Register configuration setting
# Set the full URL for the ntfy endpoint, including http:// or https://
Irssi::settings_add_str('ntfy', 'ntfy_endpoint', 'https://ntfy.sh/irssi');

# Function to send the notification
sub send_ntfy_notification {
    my ($title, $message) = @_;

    # Retrieve ntfy endpoint setting (full URL endpoint)
    my $ntfy_endpoint = Irssi::settings_get_str('ntfy_endpoint');

    # Send the POST request with plain text message
    system('curl', '-d', $message, $ntfy_endpoint);
}

# Handle messages where you are highlighted
sub highlight_notify {
    my ($server, $msg, $nick, $address, $target) = @_;
    my $message = "Mentioned by $nick in $target: $msg";
    send_ntfy_notification($ntfy_title, $message);
}

# Handle private messages
sub private_message_notify {
    my ($server, $msg, $nick, $address) = @_;
    my $message = "Private message from $nick: $msg";
    send_ntfy_notification($ntfy_title, $message);
}

# Attach handlers to Irssi signals
Irssi::signal_add('message irc action', 'highlight_notify');
Irssi::signal_add('message private', 'private_message_notify');

Irssi::print("ntfy script loaded. Example usage: /set ntfy_endpoint https://your-custom-ntfy-server/irssi");
