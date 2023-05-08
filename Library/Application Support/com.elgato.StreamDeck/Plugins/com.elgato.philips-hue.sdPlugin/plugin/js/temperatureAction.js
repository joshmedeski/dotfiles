/**
@file      temperatureAction.js
@brief     Philips Hue Plugin
@copyright (c) 2019, Corsair Memory, Inc.
@license   This source code is licensed under the MIT-style license found in the LICENSE file.
*/


function TemperatureAction(inContext, inSettings, jsn) {
  this.property = 'temperature';
  // Inherit from PropertyAction
  PropertyAction.call(this, inContext, inSettings, jsn);
}
