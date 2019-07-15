import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import 'emoji-mart/css/emoji-mart.css'
import { Picker, Emoji } from 'emoji-mart'

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
      menu_class: 'is-hidden',
      field_value: props.fieldValue,
      picker: {
        native: true,
        emoji: 'point_up',
        title: 'Pick your emoji…',
        custom: CUSTOM_EMOJIS,
      }
    }
  }

  handleTriggerClick() {
    this.setState({ menu_class: '' });
  }

  handleEmojiSelect(emoji) {
    this.setState({ field_value: emoji.id, menu_class: 'is-hidden' });
  }

  render() {
    return <div>
      <input type="hidden" name={this.props.fieldName} value={this.state.field_value}/>
      <div onClick={() => this.handleTriggerClick()}>
        <Emoji
          emoji={{ id: this.state.field_value }}
          size={32}
          fallback={(emoji, props) => {
            return emoji ? `:${emoji.short_names[0]}:` : props.emoji
          }}
        />
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
    $emojiPickers.forEach(el => {
      ReactDOM.render(
        <Example
          fieldName={el.getAttribute('data-field-name')}
          fieldValue={el.getAttribute('data-field-value') || 'grinning'}
        />,
        el
      );
    });
  }
});
