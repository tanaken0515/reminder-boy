import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import 'emoji-mart/css/emoji-mart.css'
import { Picker, Emoji } from 'emoji-mart'

class Example extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      menu_class: 'is-hidden',
      field_value: props.fieldValue,
      is_custom: props.isCustom,
      image_url: props.imageUrl,
      picker: {
        native: true,
        emoji: 'point_up',
        title: 'Pick your emoji…',
        custom: props.customEmojiList,
      }
    }
  }

  handleTriggerClick() {
    this.setState({ menu_class: '' });
  }

  handleEmojiSelect(emoji) {
    this.setState({
      field_value: emoji.id,
      is_custom: emoji.custom,
      image_url: emoji.imageUrl,
      menu_class: 'is-hidden',
    });
  }

  render() {
    let icon;
    if(this.state.field_value) {
      if(this.state.is_custom) {
        icon = <figure className="image is-32x32"><img src={this.state.image_url} alt={this.state.field_value}></img></figure>;
      } else {
        icon = <Emoji emoji={{ id: this.state.field_value }} size={32}/>;
      }
    } else {
      icon = <div className='is-size-4'><i className="far fa-smile"></i></div>;
    }

    return <div>
      <input type="hidden" name={this.props.fieldName} value={this.state.field_value}/>
      <div onClick={() => this.handleTriggerClick()}>
        {icon}
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
      const isCustom = (el.getAttribute('data-is-custom') === 'true');
      const customEmojiList = JSON.parse(el.getAttribute('data-custom-emoji-json'));

      ReactDOM.render(
        <Example
          fieldName={el.getAttribute('data-field-name')}
          fieldValue={el.getAttribute('data-field-value')}
          isCustom={isCustom}
          imageUrl={el.getAttribute('data-image-url')}
          customEmojiList={customEmojiList}
        />,
        el
      );
    });
  }
});
