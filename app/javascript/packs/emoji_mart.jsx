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
      native: true,
      emoji: 'point_up',
      title: 'Pick your emoji…',
      custom: CUSTOM_EMOJIS,
    }
  }

  render() {
    return <Picker
      {...this.state}
      onSelect={console.log}
    />
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const $emojiPickers = Array.prototype.slice.call(document.querySelectorAll('.emoji-picker'), 0);

  if ($emojiPickers.length > 0) {

    $emojiPickers.forEach(el => {
      const $emojiPickerMenu = el.appendChild(document.createElement('div'));
      $emojiPickerMenu.classList.add('emoji-picker-menu');
      $emojiPickerMenu.classList.add('is-hidden');
      ReactDOM.render(<Example />, $emojiPickerMenu);

      const $emojiPickerTrigger = el.querySelector('.emoji-picker-trigger');
      $emojiPickerTrigger.addEventListener('click', () => {
        $emojiPickerMenu.classList.toggle('is-hidden');
      });
    });
  }
});
