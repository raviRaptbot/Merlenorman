import { LightningElement, api } from 'lwc';

export default class B2COrderOnBehalfOf extends LightningElement {
    @api token;
    @api tokenType;
    @api siteId;
    @api domain;
    @api shopDomain;
    @api version;

    openPage() {
        let xhr = new XMLHttpRequest();
        xhr.open('POST', `${this.domain}/s/${this.siteId}/dw/shop/${this.version}/sessions`, true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('Authorization', `${this.tokenType} ${this.token}`);
        xhr.withCredentials = true;
        console.log("---> start");
        console.log("---> token",this.token);
        xhr.onreadystatechange = () => {
            console.log('--->readyState' , xhr.readyState);
            if (xhr.readyState === 4 && (xhr.status === 200 || xhr.status === 204)) {
                console.log('--->statusText' ,xhr.statusText);
                console.log('--->status' , xhr.status);
                console.log('--->responseURL' ,xhr.responseURL);
                window.open(`${this.shopDomain}`, '_blank');
            }
        };

        xhr.send();
    }
}