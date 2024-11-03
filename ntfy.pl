use strict;
use warnings;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = '2.3';
%IRSSI = (
    authors     => 'Roni Laukkarinen',
    contact     => 'roni@dude.fi',
    name        => 'ntfy',
    description => 'Send notifications via ntfy when mentioned or receiving a private message, using built-in Irssi highlights with simplified formatting.',
    license     => 'GPLv2',
);

# Register configuration setting
Irssi::settings_add_str('ntfy', 'ntfy_endpoint', 'https://ntfy.sh/irssi');

# Function to send the notification
sub send_ntfy_notification {
    my ($title, $message) = @_;

    # Retrieve ntfy endpoint setting (full URL endpoint)
    my $ntfy_endpoint = Irssi::settings_get_str('ntfy_endpoint');

    # Suppress output by redirecting to /dev/null
    system('curl', '-s', '-o', '/dev/null', '-d', $message, '-H', 'Title: ' . $title, '-H', 'Markdown: yes', $ntfy_endpoint);
}

# Handle highlighted messages using Irssi's built-in highlight functionality
sub highlight_notify {
    my ($dest, $text, $stripped) = @_;

    # Check if the message is highlighted
    if ($dest->{level} & (MSGLEVEL_HILIGHT | MSGLEVEL_MSGS)) {
        my $target = $dest->{target}; # Channel or private message target

        # Extract sender's nickname (first word in stripped message)
        my ($sender, $message) = split(' ', $stripped, 2);

        # Remove current user's nickname from the start of the message if it's a mention
        my $nick = $dest->{server}->{nick};
        $message =~ s/^\Q$nick\E[\s,:-]*// if defined $message; # Remove nick at start, followed by space, comma, or punctuation

        # Trim leading and trailing whitespace from the message
        $message =~ s/^\s+|\s+$//g;

        # Use "Mentioned by..." line as the title and remaining message as content
        my $title = sprintf("Mentioned by %s in %s", $sender, $target);
        send_ntfy_notification($title, $message);
    }
}

# Handle private messages
sub private_message_notify {
    my ($server, $msg, $nick, $address) = @_;
    my $title = sprintf("Private message from %s", $nick);
    send_ntfy_notification($title, $msg);
}

# Attach handlers to Irssi signals
Irssi::signal_add('print text', 'highlight_notify');
Irssi::signal_add('message private', 'private_message_notify');

Irssi::print("ntfy script loaded. Example usage: /set ntfy_endpoint https://your-custom-ntfy-server/irssi");
