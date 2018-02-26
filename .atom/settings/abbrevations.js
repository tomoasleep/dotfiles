"use babel";

import { provideService } from './utils';

const abbrevations = {
  org: 'organization',
  Org: 'Organization',
  inv: 'invitation',
  Inv: 'Invitation',
};

function getSuggestions({ prefix }) {
  return new Promise((resolve) => {
    const entries = Object.entries(abbrevations);
    resolve(entries.filter(([key, _value]) => prefix.startsWith(key)).map(([key, v]) => {
      return {
        text: v,
        rightLabel: 'abbr',
      };
    }));
  });
}

provideService('autocomplete.provider', '2.0.0', {
  selector: '*',
  getSuggestions: getSuggestions,
  label: 'abbr',
  suggestionPriority: 2,
});
