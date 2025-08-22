const express = require('express');
const router = express.Router();
const whatsappService = require('../services/whatsappService');
const { logger } = require('../utils/logger');

/**
 * WhatsApp webhook verification
 */
router.get('/', (req, res) => {
    try {
        const mode = req.query['hub.mode'];
        const token = req.query['hub.verify_token'];
        const challenge = req.query['hub.challenge'];

        if (mode && token) {
            const response = whatsappService.verifyWebhook(mode, token, challenge);
            res.status(200).send(response);
        } else {
            res.status(403).send('Forbidden');
        }
    } catch (error) {
        logger.error('Webhook verification failed:', error);
        res.status(403).send('Forbidden');
    }
});

/**
 * WhatsApp webhook for incoming messages
 */
router.post('/', (req, res) => {
    try {
        const message = whatsappService.handleIncomingMessage(req.body);
        
        if (message) {
            logger.info(`Received WhatsApp message: ${message.text} from ${message.from}`);
            // Handle the message here (e.g., process commands, send responses)
        }
        
        res.status(200).send('OK');
    } catch (error) {
        logger.error('Error processing WhatsApp webhook:', error);
        res.status(500).send('Internal Server Error');
    }
});

/**
 * Send test message via WhatsApp
 */
router.post('/send-test', async (req, res) => {
    try {
        const { phoneNumber, message } = req.body;
        
        if (!phoneNumber || !message) {
            return res.status(400).json({
                success: false,
                message: 'Phone number and message are required'
            });
        }

        const result = await whatsappService.sendSimpleMessage(phoneNumber, message);
        
        if (result.success) {
            res.status(200).json({
                success: true,
                message: 'Message sent successfully',
                data: result
            });
        } else {
            res.status(500).json({
                success: false,
                message: 'Failed to send message',
                error: result.error
            });
        }
    } catch (error) {
        logger.error('Error sending test message:', error);
        res.status(500).json({
            success: false,
            message: 'Internal server error'
        });
    }
});

module.exports = router;
