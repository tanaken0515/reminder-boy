import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import 'emoji-mart/css/emoji-mart.css'
import { Picker } from 'emoji-mart'

const CUSTOM_EMOJIS = [
  {
    name: 'Octocat',
    short_names: ['octocat'],
    keywords: ['github'],
    imageUrl: 'https://github.githubassets.com/images/icons/emoji/octocat.png'
  },
  {
    name: 'Squirrel',
    short_names: ['shipit', 'squirrel'],
    keywords: ['github'],
    imageUrl: 'https://github.githubassets.com/images/icons/emoji/shipit.png'
  },
  {
    name: 'Test Flag',
    short_names: ['test'],
    keywords: ['test', 'flag'],
    spriteUrl: 'https://unpkg.com/emoji-datasource-twitter@4.0.4/img/twitter/sheets-256/64.png',
    sheet_x: 1,
    sheet_y: 1,
    size: 64,
    sheetColumns: 52,
    sheetRows: 52,
  },
];

class Example extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      trigger_elm: 'please click!',
      menu_class: 'is-hidden',
      picker: {
        native: true,
        emoji: 'point_up',
        title: 'Pick your emoji…',
        custom: CUSTOM_EMOJIS,
      }
    }
  }

  handleTriggerClick() {
    console.log('click!');
    this.setState({ trigger_elm: 'target is clicked!', menu_class: '' });
  }

  handleEmojiSelect(emoji) {
    console.log(emoji);
    this.setState({ trigger_elm: emoji.id, menu_class: 'is-hidden' });
  }

  render() {
    return <div>
      <div onClick={() => this.handleTriggerClick()}>
        {this.state.trigger_elm}
      </div>
      <div className={this.state.menu_class}>
        <Picker
          {...this.state.picker}
          onSelect={(emoji) => this.handleEmojiSelect(emoji)}
        />
      </div>
    </div>
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const $emojiPickers = Array.prototype.slice.call(document.querySelectorAll('.emoji-picker'), 0);

  if ($emojiPickers.length > 0) {
    $emojiPickers.forEach(el => { ReactDOM.render(<Example />, el) });
  }
});
