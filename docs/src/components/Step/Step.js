import React from 'react';
import styles from './styles.module.css';
import Highlight from '../Highlight/Highlight';

export default class Step extends React.Component {
  render() {
    return <Highlight className={styles.step}>STEP {this.props.children}</Highlight>;
  }
}