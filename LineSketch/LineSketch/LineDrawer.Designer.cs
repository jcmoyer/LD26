namespace LineSketch {
    partial class LineDrawer {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.components = new System.ComponentModel.Container();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.deleteToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.insertToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripSeparator();
            this.noiseToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.flattenToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.tessellateToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.stairsLeftToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.stairsLeftToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripSeparator();
            this.portalHereToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.stairsDownRightToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.stairsDownLeftToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.locationToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripSeparator();
            this.contextMenuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.locationToolStripMenuItem,
            this.toolStripMenuItem3,
            this.deleteToolStripMenuItem,
            this.insertToolStripMenuItem,
            this.toolStripMenuItem1,
            this.noiseToolStripMenuItem,
            this.flattenToolStripMenuItem,
            this.tessellateToolStripMenuItem,
            this.stairsLeftToolStripMenuItem,
            this.stairsDownRightToolStripMenuItem,
            this.stairsLeftToolStripMenuItem1,
            this.stairsDownLeftToolStripMenuItem,
            this.toolStripMenuItem2,
            this.portalHereToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(168, 286);
            // 
            // deleteToolStripMenuItem
            // 
            this.deleteToolStripMenuItem.Name = "deleteToolStripMenuItem";
            this.deleteToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.deleteToolStripMenuItem.Text = "Delete";
            this.deleteToolStripMenuItem.Click += new System.EventHandler(this.deleteToolStripMenuItem_Click);
            // 
            // insertToolStripMenuItem
            // 
            this.insertToolStripMenuItem.Name = "insertToolStripMenuItem";
            this.insertToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.insertToolStripMenuItem.Text = "Insert";
            this.insertToolStripMenuItem.Click += new System.EventHandler(this.insertToolStripMenuItem_Click);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(149, 6);
            // 
            // noiseToolStripMenuItem
            // 
            this.noiseToolStripMenuItem.Name = "noiseToolStripMenuItem";
            this.noiseToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.noiseToolStripMenuItem.Text = "Noise";
            this.noiseToolStripMenuItem.Click += new System.EventHandler(this.noiseToolStripMenuItem_Click);
            // 
            // flattenToolStripMenuItem
            // 
            this.flattenToolStripMenuItem.Name = "flattenToolStripMenuItem";
            this.flattenToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.flattenToolStripMenuItem.Text = "Flatten";
            this.flattenToolStripMenuItem.Click += new System.EventHandler(this.flattenToolStripMenuItem_Click);
            // 
            // tessellateToolStripMenuItem
            // 
            this.tessellateToolStripMenuItem.Name = "tessellateToolStripMenuItem";
            this.tessellateToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.tessellateToolStripMenuItem.Text = "Tessellate";
            this.tessellateToolStripMenuItem.Click += new System.EventHandler(this.tessellateToolStripMenuItem_Click);
            // 
            // stairsLeftToolStripMenuItem
            // 
            this.stairsLeftToolStripMenuItem.Name = "stairsLeftToolStripMenuItem";
            this.stairsLeftToolStripMenuItem.Size = new System.Drawing.Size(167, 22);
            this.stairsLeftToolStripMenuItem.Text = "Stairs Up (Right)";
            this.stairsLeftToolStripMenuItem.Click += new System.EventHandler(this.stairsLeftToolStripMenuItem_Click);
            // 
            // stairsLeftToolStripMenuItem1
            // 
            this.stairsLeftToolStripMenuItem1.Name = "stairsLeftToolStripMenuItem1";
            this.stairsLeftToolStripMenuItem1.Size = new System.Drawing.Size(167, 22);
            this.stairsLeftToolStripMenuItem1.Text = "Stairs Up (Left)";
            this.stairsLeftToolStripMenuItem1.Click += new System.EventHandler(this.stairsLeftToolStripMenuItem1_Click);
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(149, 6);
            // 
            // portalHereToolStripMenuItem
            // 
            this.portalHereToolStripMenuItem.Name = "portalHereToolStripMenuItem";
            this.portalHereToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.portalHereToolStripMenuItem.Text = "Portal Here";
            this.portalHereToolStripMenuItem.Click += new System.EventHandler(this.portalHereToolStripMenuItem_Click);
            // 
            // stairsDownRightToolStripMenuItem
            // 
            this.stairsDownRightToolStripMenuItem.Name = "stairsDownRightToolStripMenuItem";
            this.stairsDownRightToolStripMenuItem.Size = new System.Drawing.Size(167, 22);
            this.stairsDownRightToolStripMenuItem.Text = "Stairs Down (Right)";
            this.stairsDownRightToolStripMenuItem.Click += new System.EventHandler(this.stairsDownRightToolStripMenuItem_Click);
            // 
            // stairsDownLeftToolStripMenuItem
            // 
            this.stairsDownLeftToolStripMenuItem.Name = "stairsDownLeftToolStripMenuItem";
            this.stairsDownLeftToolStripMenuItem.Size = new System.Drawing.Size(167, 22);
            this.stairsDownLeftToolStripMenuItem.Text = "Stairs Down (Left)";
            this.stairsDownLeftToolStripMenuItem.Click += new System.EventHandler(this.stairsDownLeftToolStripMenuItem_Click);
            // 
            // locationToolStripMenuItem
            // 
            this.locationToolStripMenuItem.Name = "locationToolStripMenuItem";
            this.locationToolStripMenuItem.Size = new System.Drawing.Size(167, 22);
            this.locationToolStripMenuItem.Text = "Location";
            this.locationToolStripMenuItem.Click += new System.EventHandler(this.locationToolStripMenuItem_Click);
            // 
            // toolStripMenuItem3
            // 
            this.toolStripMenuItem3.Name = "toolStripMenuItem3";
            this.toolStripMenuItem3.Size = new System.Drawing.Size(164, 6);
            // 
            // LineDrawer
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.DoubleBuffered = true;
            this.Name = "LineDrawer";
            this.contextMenuStrip1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.ToolStripMenuItem deleteToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem insertToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem noiseToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem flattenToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem tessellateToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem stairsLeftToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem stairsLeftToolStripMenuItem1;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem2;
        private System.Windows.Forms.ToolStripMenuItem portalHereToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem stairsDownRightToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem stairsDownLeftToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem locationToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItem3;
    }
}
