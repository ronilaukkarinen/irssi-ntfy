
# ntfy notification script for irssi

`ntfy.pl` is an Irssi script that sends notifications via the [ntfy](https://ntfy.sh) service when you're mentioned in a channel or receive a private message.

## Features

- Sends notifications to a fixed ntfy endpoint when you are highlighted in any channel.
- Notifies on incoming private messages.
- Customizable ntfy endpoint URL using Irssi `/set` command.

## Requirements

- **curl**: Used to send HTTP POST requests.

## Installation

1. **Download** the script and place it in your Irssi scripts directory:

   ```bash
   mkdir -p ~/.irssi/scripts
   wget -O ~/.irssi/scripts/ntfy.pl https://raw.githubusercontent.com/ronilaukkarinen/irssi-ntfy/refs/heads/master/ntfy.pl
   ```

2. **Load the script** in Irssi:

   ```irssi
   /script load ntfy
   ```

3. **Set your ntfy endpoint** (optional, only if using a custom server):

   By default, the script sends notifications to the public ntfy endpoint at `https://ntfy.sh/irssi`. To set a custom endpoint, make sure to include the protocol (`http://` or `https://`) in the URL. For example:

   ```irssi
   /set ntfy_endpoint https://your-custom-ntfy-server/irssi
   ```

4. **Test the notifications** by sending yourself a private message or getting mentioned in a channel.

## Usage

- The script automatically sends notifications when:
- You're mentioned in a public channel.
- You receive a private message.

To check if the endpoint URL is set correctly, you can run:

```irssi
/set ntfy_endpoint
```

## Author

- **Roni Laukkarinen**
- **Contact**: [roni@dude.fi](mailto:roni@dude.fi)

## License

This project is licensed under the GPLv2.
